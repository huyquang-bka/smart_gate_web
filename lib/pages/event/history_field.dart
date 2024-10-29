import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_gate_web/configs/api_route.dart';
import 'package:smart_gate_web/helpers/utils.dart';
import 'package:smart_gate_web/models/event_ai.dart';
import 'package:smart_gate_web/models/event_image_video.dart';
import 'package:smart_gate_web/models/event_web.dart';
import 'package:smart_gate_web/networks/http.dart';

class HistoryField extends StatefulWidget {
  const HistoryField({super.key, required this.onViewEvent});

  final Function(EventAi) onViewEvent;

  @override
  State<HistoryField> createState() => _HistoryFieldState();
}

class _HistoryFieldState extends State<HistoryField> {
  List<EventAi> eventsAi = [];
  int currentPage = 1;
  int totalPage = 1;
  int totalItems = 0;
  static const itemsPerPage = 10;
  bool isLastPage = false;
  bool isLoading = false;
  String? selectedEventId; // Track selected event ID

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    setState(() {
      isLoading = true;
    });
    final url =
        "$urlGetEvent?sortBy=timeInOut&sortDesc=true&page=$currentPage&itemsPerPage=$itemsPerPage&filterCheckPoint=2079";
    try {
      final response = await customHttpClient.get(url);
      final jsonData = jsonDecode(response.body);
      totalItems = jsonData["totalRows"];
      totalPage = (totalItems / itemsPerPage).ceil();
      final List<dynamic> data = jsonData["data"];
      final List<EventWeb> events =
          data.map((e) => EventWeb.fromJson(e)).toList();
      setState(() {
        eventsAi = events.map(eventWebToEventAi).toList();
        isLastPage = eventsAi.length < itemsPerPage;
        isLoading = false;
      });
    } catch (e) {
      print("Error when fetching events: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void nextPage() {
    if (!isLastPage) {
      setState(() {
        currentPage++;
      });
      fetchEvents();
    }
  }

  void previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      fetchEvents();
    }
  }

  void goToFirstPage() {
    setState(() {
      currentPage = 1;
    });
    fetchEvents();
  }

  void goToLastPage() {
    setState(() {
      currentPage = totalPage;
    });
    fetchEvents();
  }

  Future<void> onViewEvent(EventAi event) async {
    String url = "$urlGetImageVideoInOut/${event.eventId}";
    final response = await customHttpClient.get(url);
    final jsonData = jsonDecode(response.body);
    EventImageVideo eventImageVideo = EventImageVideo.fromJson(jsonData);
    updateEventAiWithImageVideo(event, eventImageVideo);

    setState(() {
      selectedEventId = event.eventId; // Set selected event ID
    });

    widget.onViewEvent(event);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'History',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: isLoading ? null : fetchEvents,
                icon: const Icon(Icons.refresh),
                label: const Text('Reload'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            buildHistoryTable(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.first_page),
                onPressed: () => goToFirstPage(),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: currentPage > 1 ? previousPage : null,
              ),
              Text('Page $currentPage of $totalPage'),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: !isLastPage ? nextPage : null,
              ),
              IconButton(
                icon: const Icon(Icons.last_page),
                onPressed: () => goToLastPage(),
              ),
              const SizedBox(width: 16),
              Text('Total Items: $totalItems'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHistoryTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Time')),
          DataColumn(label: Text('Tractor LP')),
          DataColumn(label: Text('Trailer LP')),
          DataColumn(label: Text('CONT1')),
          DataColumn(label: Text('CONT2')),
          DataColumn(label: Text('Damage')),
          DataColumn(label: Text('Action')),
        ],
        rows: eventsAi.map((event) {
          return DataRow(
            color: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (event.eventId == selectedEventId) {
                  return Colors.blue[100]; // Highlight selected row
                } else if (event.isDamage) {
                  return Colors.red[100];
                }
                return null;
              },
            ),
            cells: [
              DataCell(Text(event.timeInOut)),
              DataCell(Text(event.tractorLicensePlate ?? '-')),
              DataCell(Text(event.trailerLicensePlate ?? '-')),
              DataCell(Text(event.containerCode1 ?? '-')),
              DataCell(Text(event.containerCode2 ?? '-')),
              DataCell(Text(event.isDamage ? 'Yes' : 'No')),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () => onViewEvent(event),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
