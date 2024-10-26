import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_gate_web/models/event_ai.dart';
import 'package:smart_gate_web/networks/mqtt.dart';
import 'detail_field.dart';
import 'image_field.dart';

class EventView extends StatefulWidget {
  const EventView({super.key});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView>
    with AutomaticKeepAliveClientMixin {
  //Event
  EventAi? currentEventAi;
  // MQTT configuration
  static const String _broker = 'ws://192.168.1.199';
  static const int _port = 9001;
  static const String _username = 'admin';
  static const String _password = "admin";
  static const String _topic = "Event/Container";
  static const int _checkpointId = 2079;
  final String _clientId = DateTime.now().millisecondsSinceEpoch.toString();

  late MQTTClient mqttClient;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    connectMQTT();
  }

  Future<void> connectMQTT() async {
    mqttClient = MQTTClient(
      broker: _broker,
      port: _port,
      clientId: _clientId,
      username: _username,
      password: _password,
      topic: _topic,
      onMessageReceived: onMessageReceived,
    );
    await mqttClient.connect();
  }

  void onMessageReceived(String message) {
    try {
      EventAi newEventAi = EventAi.fromJson(jsonDecode(message));
      if (newEventAi.checkPointId == _checkpointId) {
        setState(() {
          currentEventAi = newEventAi;
          print(currentEventAi?.toJson());
        });
      }
    } catch (e) {
      print("Error from getting event: $e");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: DetailsField(event: currentEventAi),
              ),
              const SizedBox(width: 32),
              Expanded(
                flex: 1,
                child: ImageField(event: currentEventAi),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
