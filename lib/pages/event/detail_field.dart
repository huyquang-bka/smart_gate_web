import 'package:flutter/material.dart';
import 'package:smart_gate_web/models/event_ai.dart';

class DetailsField extends StatelessWidget {
  const DetailsField({super.key, required this.event});

  final EventAi? event;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Inspection Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              buildInfoField('Time in/out', event?.timeInOut ?? 'unknown'),
              buildInfoField('Tractor license plate',
                  event?.tractorLicensePlate ?? 'unknown'),
              buildInfoField('Trailer license plate',
                  event?.trailerLicensePlate ?? 'unknown'),
              buildInfoField('CONT 1', event?.containerCode1 ?? 'unknown'),
              buildInfoField('CONT 2', event?.containerCode2 ?? 'unknown'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInfoField(String label, String value) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(value.isEmpty ? '-' : value),
        ],
      ),
    );
  }
}
