import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_browser_client.dart';
import 'dart:async';

class MQTTClient {
  final String broker;
  final int port;
  final String clientId;
  final String username;
  final String password;
  final String topic;
  final Function(String) onMessageReceived;
  MqttBrowserClient? client;

  MQTTClient({
    required this.broker,
    required this.port,
    required this.clientId,
    required this.username,
    required this.password,
    required this.topic,
    required this.onMessageReceived,
  });

  Future<void> connect() async {
    client = MqttBrowserClient(broker, clientId);
    client!.port = port;

    client!.logging(on: true);
    client!.keepAlivePeriod = 20;

    client!.onDisconnected = _onDisconnected;
    client!.onConnected = _onConnected;
    client!.onSubscribed = _onSubscribed;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .authenticateAs(username, password)
        .startClean();

    client!.connectionMessage = connMess;

    try {
      await client!.connect();
    } on Exception {
      client!.disconnect();
    }

    if (client!.connectionStatus!.state == MqttConnectionState.connected) {
      client!.subscribe(topic, MqttQos.atLeastOnce);

      client!.updates.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        final recMess = messages[0].payload as MqttPublishMessage;
        final String message =
            MqttUtilities.bytesToStringAsString(recMess.payload.message!);
        onMessageReceived(message);
      });
    } else {
      client!.disconnect();
    }
  }

  void _onConnected() {}

  void _onDisconnected() {
    if (client!.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {}
  }

  void _onSubscribed(MqttSubscription subscription) {}

  Future<void> sendMessage(String message) async {
    if (client?.connectionStatus?.state == MqttConnectionState.connected) {
      final builder = MqttPayloadBuilder();
      builder.addString(message);

      client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    }
  }

  void disconnect() {
    client?.disconnect();
  }
}
