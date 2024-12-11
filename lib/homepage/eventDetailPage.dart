import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetailPage extends StatelessWidget {
  final Map<String, String> event;

  // Constructor to receive event data
  EventDetailPage({required this.event});

  // Format waktu
  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime); // Format jam:menit
  }

  // Format tanggal
  String _formatDate(DateTime dateTime) {
    return DateFormat('EEEE, MMM dd')
        .format(dateTime); // Contoh: Wednesday, Feb 11
  }

  // Model tanggal dan waktu
  Widget _buildLiveTimeAndDate() {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final now = DateTime.now();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatTime(now),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 1),
            Text(
              _formatDate(now),
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Inter',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Stack(
        children: [
          // Back button
          Positioned(
            top: 70,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // Date and time
          Positioned(
            top: 70,
            right: 20,
            child: _buildLiveTimeAndDate(),
          ),
          // Title and table
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 130),
                const Text(
                  'Event Detail',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                      },
                      border: TableBorder.all(color: Colors.grey.shade300),
                      children: [
                        _buildTableRow('Information', event['information']),
                        _buildTableRow('Event Date', event['event_date']),
                        _buildTableRow('Event Time', event['event_time']),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String key, String? value) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            key,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value ?? 'N/A',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }
}
