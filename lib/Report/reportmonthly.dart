import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:worktrack/navbar.dart';
import 'package:worktrack/Report/reportdetail.dart';

void main() {
  runApp(const ReportMonthlyApp());
}

class ReportMonthlyApp extends StatelessWidget {
  const ReportMonthlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ReportPage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final Dio _dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:8000/api/showreport?month=2024-11'));
  List<dynamic> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReports('2024-11'); // Default filter for November 2024
  }

  Future<void> _fetchReports(String month) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response =
          await _dio.get('/reports', queryParameters: {'month': month});
      setState(() {
        // Sort the reports by absence_date
        _reports = response.data['data'];
        _reports.sort((a, b) => a['absence_date'].compareTo(b['absence_date']));
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching reports: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'REPORT',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            fontFamily: 'Urbanist',
          ),
        ),
        centerTitle: true,
        toolbarHeight: 100,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  color: Colors.black,
                  onPressed: () {
                    _fetchReports('2024-10'); // Fetch data for October
                  },
                ),
                const Text(
                  'November 2024',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: Colors.black,
                  onPressed: () {
                    _fetchReports('2024-12'); // Fetch data for December
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
                              DataColumn(
                                label: Text(
                                  'Date',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Clock In',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Clock Out',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Activity Title',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            rows: _reports.map((report) {
                              return DataRow(
                                  cells: [
                                    DataCell(Text(
                                      report['absence_date']?.toString() ?? '-',
                                    )),
                                    DataCell(Text(
                                      report['clock_in'] ?? '-',
                                      style: TextStyle(
                                        color: _getClockInColor(
                                            report['clock_in']),
                                      ),
                                    )),
                                    DataCell(Text(
                                      report['clock_out'] ?? '-',
                                      style: TextStyle(
                                        color: _getClockOutColor(
                                            report['clock_out']),
                                      ),
                                    )),
                                    DataCell(Text(
                                      report['activity_title'] ?? '-',
                                    )),
                                  ]);
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

  // Determine clock_in color
  Color _getClockInColor(String? clockIn) {
    if (clockIn == null) return Colors.black;
    final time = TimeOfDay(
        hour: int.parse(clockIn.split(':')[0]),
        minute: int.parse(clockIn.split(':')[1]));
    return time.hour > 8 || (time.hour == 8 && time.minute > 0)
        ? Colors.red
        : Colors.green;
  }

  // Determine clock_out color
  Color _getClockOutColor(String? clockOut) {
    if (clockOut == null) return Colors.black;
    final time = TimeOfDay(
        hour: int.parse(clockOut.split(':')[0]),
        minute: int.parse(clockOut.split(':')[1]));
    return time.hour < 17 ? Colors.red : Colors.green;
  }
}
