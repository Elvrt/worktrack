import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:worktrack/Report/reportdetail.dart';
import 'package:worktrack/navbar.dart';
import 'package:intl/intl.dart';
import 'package:worktrack/login.dart';

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

  // Inisialisasi Dio dengan authToken
  void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: '${urlDomain}api',
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    ));
  }

  // Fungsi untuk mengambil data laporan berdasarkan bulan
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

  // Fungsi untuk berpindah bulan
  void _changeMonth(String newMonth) {
    setState(() {
      _currentMonth = newMonth;
    });
    _fetchReports(newMonth);
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
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                letterSpacing: 4,
                fontFamily: 'inter',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Header untuk navigasi bulan
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
                    _changeMonth('2024-10'); // Pindah ke bulan Oktober
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
                  textAlign: TextAlign.center,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: Colors.black,
                  onPressed: () {
                    _changeMonth('2024-11'); // Pindah ke bulan Desember
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Tabel laporan
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
                                  'Detail',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportDetail(
              // reportId: report['id'], // Pass the specific report ID
            ),
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

  // Format tanggal menjadi 'dd'
  String _formatDate(String? date) {
    if (date == null) return '-';
    final parsedDate = DateTime.parse(date);
    return '${parsedDate.day.toString().padLeft(2, '0')}';
  }

  // Format waktu menjadi 'h:i'
  String _formatTime(String? time) {
    if (time == null) return '-';
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  // Fungsi untuk mendapatkan nama bulan dari format YYYY-MM
  String _getMonthName(String month) {
    final date = DateTime.parse(month + '-01');
    return '${date.month == 11 ? "November" : date.month == 12 ? "December" : "October"} ${date.year}';
  }

  // Fungsi untuk menentukan warna teks clock_in
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

  // model tanggal dan waktu
  String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime); // Format jam:menit
  }

  // Format tanggal
  String formatDate(DateTime dateTime) {
    return DateFormat('EEEE, MMM dd')
        .format(dateTime); // Contoh: Wednesday, Feb 11
  }

  // model tanggal dan waktu
  Widget _buildLiveTimeAndDate() {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final now = DateTime.now();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formatTime(now),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 1),
            Text(
              formatDate(now),
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

}
