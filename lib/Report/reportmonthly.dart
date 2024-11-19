import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000/api/showreport'));
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
      final response = await _dio.get('/reports', queryParameters: {'month': month});
      setState(() {
        _reports = response.data['data'];
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
                    // Fetch data for the previous month
                    _fetchReports('2024-10'); // Example for October
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
                    // Fetch data for the next month
                    _fetchReports('2024-12'); // Example for December
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
                      child: ListView.builder(
                        itemCount: _reports.length,
                        itemBuilder: (context, index) {
                          final report = _reports[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  report['absence_date'] ?? '-',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  report['clock_in'] ?? '-',
                                  style: const TextStyle(
                                    color: Color(0xFF09740E),
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  report['clock_out'] ?? '-',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  report['activity_title'] ?? '-',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}
