import 'package:flutter/material.dart';
import 'package:smart_gate_web/configs/api_route.dart';
import 'package:smart_gate_web/configs/constant.dart';
import 'package:smart_gate_web/models/event_ai.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class ImageField extends StatelessWidget {
  const ImageField({super.key, required this.event});
  final EventAi? event;

  @override
  Widget build(BuildContext context) {
    Map<String, List<String>> images = {
      'Tractor': [
        event?.tractorLicensePlate ?? '',
        event?.imgTractor ?? '',
        event?.vidTractor ?? '',
      ],
      'Trailer': [
        event?.trailerLicensePlate ?? '',
        event?.imgTrailer ?? '',
        event?.vidTrailer ?? '',
      ],
      'Left 1': [
        event?.containerCode1 ?? '',
        event?.imgLeft1 ?? '',
        event?.vidLeft ?? '',
      ],
      'Left 2': [
        event?.containerCode2 ?? '',
        event?.imgLeft2 ?? '',
        event?.vidLeft ?? '',
      ],
      'Right 1': [
        event?.containerCode1 ?? '',
        event?.imgRight1 ?? '',
        event?.vidRight ?? '',
      ],
      'Right 2': [
        event?.containerCode2 ?? '',
        event?.imgRight2 ?? '',
        event?.vidRight ?? '',
      ],
      'Top 1': [
        'Top 1',
        event?.imgTop1 ?? '',
        event?.vidTop ?? '',
      ],
      'Top 2': [
        'Top 2',
        event?.imgTop2 ?? '',
        event?.vidTop ?? '',
      ],
      'Front 1': [
        'Front 1',
        event?.imgFront1 ?? '',
        event?.vidFront ?? '',
      ],
      'Front 2': [
        'Front 2',
        event?.imgFront2 ?? '',
        event?.vidFront ?? '',
      ],
      'Door 1': [
        'Door 1',
        event?.imgDoor1 ?? '',
        '',
      ],
      'Door 2': [
        'Door 2',
        event?.imgDoor2 ?? '',
        '',
      ],
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Images',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: List.generate(12, (index) {
            return buildImagePlaceholder(images.keys.elementAt(index),
                images.values.elementAt(index), context);
          }),
        ),
      ],
    );
  }

  Widget buildImagePlaceholder(
      String label, List<String> imageInfo, BuildContext context) {
    String imageLabel = imageInfo[0];
    String imagePath = imageInfo[1];
    String videoPath = imageInfo[2];

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              buildImageVideoDialog(imageLabel, imagePath, videoPath, context),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.all(paddingAll),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 12)),
            Expanded(
              child: Center(
                child: imagePath.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          "$urlFileService/$imagePath",
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.image,
                        size: iconSize, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageVideoDialog(
      String label, String imagePath, String videoPath, BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(paddingAll),
        ),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(text: 'Image'),
                  Tab(text: 'Video'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // Image Tab
                    Padding(
                      padding: const EdgeInsets.all(paddingAll),
                      child: Center(
                        child: imagePath.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  "$urlFileService/$imagePath",
                                  fit: BoxFit.contain,
                                ),
                              )
                            : const Icon(Icons.image,
                                size: 200, color: Colors.grey),
                      ),
                    ),
                    // Video Tab
                    videoPath.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(paddingAll),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: VideoPlayer(
                                videoPath: "$urlFileService/$videoPath",
                              ),
                            ),
                          )
                        : const Center(child: Text('No video available')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoPlayer extends StatefulWidget {
  final String videoPath;

  const VideoPlayer({Key? key, required this.videoPath}) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    player.open(Media(widget.videoPath));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Video(controller: controller);
  }
}
