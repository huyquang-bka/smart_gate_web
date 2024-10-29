import 'package:flutter/material.dart';
import 'package:smart_gate_web/pages/event/event_view.dart';
import 'package:smart_gate_web/pages/tabs/camera/camera_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final List<Camera> cameras = [
    Camera(
        id: '1',
        deviceName: 'Tractor',
        linkLocation: 'http://192.168.1.199:18080/CHP_stream/tractor/hls.m3u8'),
    Camera(
        id: '2',
        deviceName: 'Trailer',
        linkLocation: 'http://192.168.1.199:18080/CHP_stream/trailer/hls.m3u8'),
    Camera(
        id: '3',
        deviceName: 'Rear',
        linkLocation: 'http://192.168.1.199:18080/CHP_stream/rear/hls.m3u8'),
    Camera(
        id: '4',
        deviceName: 'Front',
        linkLocation: 'http://192.168.1.199:18080/CHP_stream/front/hls.m3u8'),
    Camera(
        id: '5',
        deviceName: 'Right',
        linkLocation: 'http://192.168.1.199:18080/CHP_stream/right/hls.m3u8'),
    Camera(
        id: '7',
        deviceName: 'Top',
        linkLocation: 'http://192.168.1.199:18080/CHP_stream/top/hls.m3u8'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home Page'),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       AuthService.clearAuth();
        //       Navigator.of(context).pushReplacement(
        //           MaterialPageRoute(builder: (context) => const AuthPage()));
        //     },
        //     icon: const Icon(Icons.logout),
        //   ),
        // ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Events'),
            Tab(text: 'Cameras'),
          ],
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          const EventView(),
          CameraPage(cameras: cameras),
        ],
      ),
    );
  }
}
