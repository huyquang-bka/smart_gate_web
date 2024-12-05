import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_gate_web/configs/api_route.dart';
import 'package:smart_gate_web/models/event_ai.dart';
import 'package:smart_gate_web/networks/no-auth-http.dart';

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
  bool isError = false;
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
    String url =
        "$urlGetEvent?page=$currentPage&page_size=$itemsPerPage&checkpoint_id=2079";
    if (isError) {
      url =
          "$urlGetEvent?page=$currentPage&page_size=$itemsPerPage&checkpoint_id=2079&is_error=$isError";
    }
    try {
      final response = await noAuthHttpClient.get(url);
      final jsonData = jsonDecode(response.body);
      totalItems = jsonData["Total"];
      totalPage = jsonData["TotalPages"];
      final List<dynamic> data = jsonData["Items"];
      final List<EventAi> events =
          data.map((e) => EventAi.fromJson(e)).toList();
      setState(() {
        eventsAi = events;
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
              Row(
                children: [
                  Checkbox(
                    value: isError,
                    onChanged: (bool? value) {
                      setState(() {
                        isError = value ?? false;
                        currentPage = 1; // Reset to first page
                      });
                      fetchEvents();
                    },
                  ),
                  const Text('Show Errors Only'),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : fetchEvents,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reload'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Center(child: buildHistoryTable()),
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
        ],
        rows: eventsAi.map((event) {
          return DataRow(
            color: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (event.eventId == selectedEventId) {
                  return Colors.blue[100]; // Highlight selected row
                } else if (isError || event.isError == true) {
                  return Colors.red[100];
                } else if (event.imgDoor1 != null || event.imgFront1 != null) {
                  return Colors.green[100];
                }
                return null;
              },
            ),
            cells: [
              buildHistoryCell(event.timeInOut, event),
              buildHistoryCell(event.tractorLicensePlate ?? '-', event),
              buildHistoryCell(event.trailerLicensePlate ?? '-', event),
              buildHistoryCell(event.containerCode1 ?? '-', event),
              buildHistoryCell(event.containerCode2 ?? '-', event),
            ],
          );
        }).toList(),
      ),
    );
  }

  DataCell buildHistoryCell(String text, EventAi event) {
    return DataCell(Text(text), onTap: () => onViewEvent(event));
  }
}
