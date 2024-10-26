import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class Camera {
  final String id;
  final String deviceName;
  final String linkLocation;

  Camera({
    required this.id,
    required this.deviceName,
    required this.linkLocation,
  });
}

class CameraView extends StatefulWidget {
  final Camera camera;
  final Function(Player) onPlayerInitialized;
  final Function(Function) onReloadCallback;

  const CameraView({
    super.key,
    required this.camera,
    required this.onPlayerInitialized,
    required this.onReloadCallback,
  });

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView>
    with AutomaticKeepAliveClientMixin {
  late Player _player;
  late VideoController _videoController;
  bool _isPlayerInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    widget.onReloadCallback(_reloadPlayer);
  }

  Future<void> _initializePlayer() async {
    setState(() => _isPlayerInitialized = false);

    _player = Player();
    _videoController = VideoController(_player);
    String rtspUrl = widget.camera.linkLocation;

    try {
      await _player.open(Media(rtspUrl), play: false);
      setState(() {
        _isPlayerInitialized = true;
      });
      widget.onPlayerInitialized(_player);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading video stream')),
        );
      }
    }
  }

  Future<void> _reloadPlayer() async {
    await _player.dispose();
    await _initializePlayer();
    // Auto-start playing after reload
    if (_isPlayerInitialized) {
      _player.play();
    }
  }

  void _handlePlayCamera() {
    if (!_player.state.playing) {
      _player.play();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              widget.camera.deviceName,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Center(
              child: _isPlayerInitialized
                  ? Video(controller: _videoController)
                  : const CircularProgressIndicator(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.play_arrow, size: 20),
                onPressed: _handlePlayCamera,
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                onPressed: _reloadPlayer,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CameraPage extends StatefulWidget {
  final List<Camera> cameras;

  const CameraPage({super.key, required this.cameras});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final List<Player> _players = [];
  final List<Function> _reloadCallbacks = [];

  void _handleReloadAll() async {
    // Execute all reload callbacks
    for (var reloadCallback in _reloadCallbacks) {
      await reloadCallback();
    }
  }

  void _addPlayer(Player player) {
    _players.add(player);
  }

  void _addReloadCallback(Function callback) {
    _reloadCallbacks.add(callback);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _handleReloadAll,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 20),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Reload All Cameras'),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 16 / 9,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            padding: const EdgeInsets.all(15),
            itemCount: widget.cameras.length,
            itemBuilder: (context, index) {
              return CameraView(
                camera: widget.cameras[index],
                onPlayerInitialized: _addPlayer,
                onReloadCallback: _addReloadCallback,
              );
            },
          ),
        ),
      ],
    );
  }
}
