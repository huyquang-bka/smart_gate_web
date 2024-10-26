import 'package:flutter/material.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_browser_client.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MQTT5 Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MQTTPage(title: 'Flutter MQTT5 Demo'),
    );
  }
}

class MQTTPage extends StatefulWidget {
  const MQTTPage({super.key, required this.title});
  final String title;

  @override
  State<MQTTPage> createState() => _MQTTPageState();
}

class _MQTTPageState extends State<MQTTPage> {
  // MQTT Configuration
  static const String _broker = 'ws://192.168.1.199';
  static const int _port = 9001; // 8080 for ws, 8081 for wss
  static const String _username = 'admin';
  static const String _password = 'admin';
  static const String _topic = 'Test/Container';
  static const String _clientId = 'flutter_client_060299asdasdrqweafasd';

  MqttBrowserClient? client;
  final TextEditingController _messageController = TextEditingController();
  String _status = 'Disconnected';
  List<String> _receivedMessages = [];

  @override
  void initState() {
    super.initState();
    _setupMqttClient();
  }

  Future<void> _setupMqttClient() async {
    client = MqttBrowserClient(_broker, _clientId);
    client!.port = _port;

    // Set logging and keep alive
    client!.logging(on: true);
    client!.keepAlivePeriod = 20;

    // Set callbacks
    client!.onDisconnected = _onDisconnected;
    client!.onConnected = _onConnected;
    client!.onSubscribed = _onSubscribed;
    client!.pongCallback = _pong;

    // Create a connection message
    final connMess = MqttConnectMessage()
        .withClientIdentifier(_clientId)
        .authenticateAs(_username, _password)
        .startClean(); // Non persistent session for testing

    print('MQTT::Connecting to broker....');
    client!.connectionMessage = connMess;

    try {
      await client!.connect();
    } on Exception catch (e) {
      print('MQTT::Client exception - $e');
      client!.disconnect();
    }

    if (client!.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT::Client connected');

      // Subscribe to topic
      print('MQTT::Subscribing to the $_topic topic');
      client!.subscribe(_topic, MqttQos.atLeastOnce);

      // Listen for messages
      client!.updates.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        final recMess = messages[0].payload as MqttPublishMessage;
        final String message =
            MqttUtilities.bytesToStringAsString(recMess.payload.message!);

        setState(() {
          _receivedMessages.add('Received: $message');
        });
        print(
            'MQTT::Change notification:: topic is <${messages[0].topic}>, payload is <-- $message -->');
      });

      // Listen for published messages
      client!.published!.listen((MqttPublishMessage message) {
        print(
            'MQTT::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
      });
    } else {
      print(
          'MQTT::ERROR Client connection failed - disconnecting, status is ${client!.connectionStatus}');
      client!.disconnect();
    }
  }

  void _onConnected() {
    setState(() {
      _status = 'Connected';
    });
    print(
        'MQTT::OnConnected client callback - Client connection was successful');
  }

  void _onDisconnected() {
    setState(() {
      _status = 'Disconnected';
    });
    print('MQTT::OnDisconnected client callback - Client disconnection');
    if (client!.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('MQTT::OnDisconnected callback is solicited, this is correct');
    }
  }

  void _onSubscribed(MqttSubscription subscription) {
    print(
        'MQTT::Subscription confirmed for topic ${subscription.topic.rawTopic}');
  }

  void _pong() {
    print('MQTT::Ping response client callback invoked');
  }

  void _publishMessage() {
    if (client?.connectionStatus?.state == MqttConnectionState.connected) {
      final builder = MqttPayloadBuilder();
      builder.addString(_messageController.text);

      print('MQTT::Publishing message to $_topic');
      client!.publishMessage(_topic, MqttQos.atLeastOnce, builder.payload!);

      setState(() {
        _receivedMessages.add('Sent: ${_messageController.text}');
      });
      _messageController.clear();
    } else {
      print('MQTT::Client is not connected');
    }
  }

  @override
  void dispose() {
    print('MQTT::Disconnecting...');
    client?.disconnect();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text('Broker: $_broker'),
                    Text('Port: $_port'),
                    Text('Topic: $_topic'),
                    Text('Status: $_status'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _publishMessage,
                  child: const Text('Send'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _receivedMessages.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_receivedMessages[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
