import 'package:flutter/material.dart';
import 'package:smart_gate_web/configs/api_route.dart';
import 'package:smart_gate_web/configs/constant.dart';
import 'package:smart_gate_web/models/event_ai.dart';

class ImageField extends StatelessWidget {
  const ImageField({super.key, required this.event});
  final EventAi? event;

  @override
  Widget build(BuildContext context) {
    Map<String, List<String>> images = {
      'Tractor': [event?.imgTractor ?? '', event?.tractorLicensePlate ?? ''],
      'Trailer': [event?.imgTrailer ?? '', event?.trailerLicensePlate ?? ''],
      'Left 1': [event?.imgLeft1 ?? '', event?.containerCode1 ?? ''],
      'Left 2': [event?.imgLeft2 ?? '', event?.containerCode2 ?? ''],
      'Right 1': [event?.imgRight1 ?? '', event?.containerCode1 ?? ''],
      'Right 2': [event?.imgRight2 ?? '', event?.containerCode2 ?? ''],
      'Top 1': [event?.imgTop1 ?? '', 'Top 1'],
      'Top 2': [event?.imgTop2 ?? '', 'Top 2'],
      'Front 1': [event?.imgFront1 ?? '', 'Front 1'],
      'Front 2': [event?.imgFront2 ?? '', 'Front 2'],
      'Door 1': [event?.imgDoor1 ?? '', 'Door 1'],
      'Door 2': [event?.imgDoor2 ?? '', 'Door 2'],
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
    String imagePath = imageInfo.first;
    String imageLabel = imageInfo.last;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              buildImageDialog(imageLabel, imagePath, context),
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

  Widget buildImageDialog(
      String label, String imagePath, BuildContext context) {
    return Dialog(
      child: SizedBox(
        child: Column(
          children: [
            Text(label,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(paddingAll),
                child: Center(
                  child: imagePath.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "$urlFileService/$imagePath",
                            fit: BoxFit.fill,
                          ),
                        )
                      : const Icon(Icons.image, size: 200, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
