import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:worktrack/Report/reportdetail.dart';
import 'package:worktrack/navbar.dart';
import 'package:intl/intl.dart';
import 'package:worktrack/login.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late Dio _dio;
  List<dynamic> _reports = [];
  bool _isLoading = true;
  String _currentMonth = '2024-11'; // Default bulan November 2024

  @override
  void initState() {
    super.initState();
    _initializeDio(); // Inisialisasi Dio dengan token
    _fetchReports(_currentMonth); // Ambil laporan berdasarkan bulan default
  }

  void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: '${urlDomain}api',
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    ));
  }

  Future<void> _fetchReports(String month) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response =
          await _dio.get('/report', queryParameters: {'month': month});
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        setState(() {
          _reports = response.data['data'] ?? [];
          _reports
              .sort((a, b) => a['absence_date'].compareTo(b['absence_date']));
          _isLoading = false;
        });
      } else {
        setState(() {
          _reports = [];
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _changeMonth(int offset) {
    setState(() {
      DateTime currentDate = DateTime.parse('$_currentMonth-01');
      DateTime newDate =
          DateTime(currentDate.year, currentDate.month + offset);
      _currentMonth =
          '${newDate.year}-${newDate.month.toString().padLeft(2, '0')}';
    });
    _fetchReports(_currentMonth);
  }

  String _getMonthName(String month) {
    final date = DateTime.parse('$month-01');
    return DateFormat('MMMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildLiveTimeAndDate(),
          ],
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              'REPORT',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                letterSpacing: 4,
                fontFamily: 'inter',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 51,
            decoration: BoxDecoration(
              color: const Color(0x56FFD83A),
              border: Border.all(
                color: Colors.black.withOpacity(0.1),
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  color: Colors.black,
                  onPressed: () {
                    _changeMonth(-1); // Mundur satu bulan
                  },
                ),
                Text(
                  _getMonthName(_currentMonth),
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: Colors.black,
                  onPressed: () {
                    _changeMonth(1); // Maju satu bulan
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _reports.isEmpty
                  ? const Center(child: Text('No reports found'))
                  : Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Date')),
                              DataColumn(label: Text('Clock In')),
                              DataColumn(label: Text('Clock Out')),
                              DataColumn(label: Text('Detail')),
                            ],
                            rows: _reports.map((report) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(
                                    _formatDate(
                                        report['absence']['absence_date']),
                                  )),
                                  DataCell(Text(
                                    _formatTime(report['absence']['clock_in']),
                                    style: TextStyle(
                                      color: _getClockInColor(
                                          report['absence']['clock_in']),
                                    ),
                                  )),
                                  DataCell(Text(
                                    _formatTime(report['absence']['clock_out']),
                                    style: TextStyle(
                                      color: _getClockOutColor(
                                          report['absence']['clock_out']),
                                    ),
                                  )),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: IconButton(
                                        icon: const Icon(Icons.info_outline),
                                        iconSize: 24,
                                        onPressed: () {
                                          final reportId = report['report_id'];
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReportDetail(reportId: reportId),
                                            ),
                                          );
                                        },
                                                 ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }

  String _formatDate(String? date) {
    if (date == null) return '-';
    final parsedDate = DateTime.parse(date);
    return '${parsedDate.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(String? time) {
    if (time == null) return '-';
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  Widget _buildLiveTimeAndDate() {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final now = DateTime.now();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormat('HH:mm').format(now),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              DateFormat('EEEE, MMM dd').format(now),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        );
      },
    );
  }
  Color _getClockInColor(String? clockIn) {
    if (clockIn == null) return Colors.black;
    final time = TimeOfDay(
      hour: int.parse(clockIn.split(':')[0]),
      minute: int.parse(clockIn.split(':')[1]),
    );
    return time.hour > 8 || (time.hour == 8 && time.minute > 0)
        ? Colors.red
        : Colors.green;
  }

  // Fungsi untuk menentukan warna teks clock_out
  Color _getClockOutColor(String? clockOut) {
    if (clockOut == null) return Colors.black;
    final time = TimeOfDay(
      hour: int.parse(clockOut.split(':')[0]),
      minute: int.parse(clockOut.split(':')[1]),
    );
    return time.hour < 17 ? Colors.red : Colors.green;
  }
}
