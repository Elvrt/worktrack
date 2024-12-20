import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:worktrack/navbar.dart';
import 'package:worktrack/login.dart';
import 'package:intl/intl.dart';

class ReportDetail extends StatefulWidget {
  final int reportId; // Menyimpan ID laporan yang diterima dari parameter

  const ReportDetail({super.key, required this.reportId});

  @override
  State<ReportDetail> createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail> {
  late Dio _dio;
  Map<String, dynamic>? _reportData;
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initializeDio();
    _fetchReportDetails(widget.reportId);
  }

  // Inisialisasi Dio dengan token
  void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: '${urlDomain}api',
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    ));
  }

  // Mengambil data laporan berdasarkan ID
  Future<void> _fetchReportDetails(int id) async {
    try {
      final response = await _dio.get('/report/show/$id');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        setState(() {
          _reportData = response.data['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isError = true;
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    }
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
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Colors.black,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _isError
            ? const Center(child: Text('Failed to load report details'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      'REPORT DETAIL',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        letterSpacing: 4,
                        fontFamily: 'inter',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildReportDetails(),
                  ),
                ],
              ),
    bottomNavigationBar: BottomNavBar(currentIndex: 0),
  );
}


  // Menampilkan detail laporan
  Widget _buildReportDetails() {
    return Column(
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
          child: Text(
            _reportData!['absence']['absence_date'],
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 30),
        _buildClockInOut('Clock In', _reportData!['absence']['clock_in']),
        const SizedBox(height: 30),
       _buildClockInOut('Clock Out', _reportData!['absence']['clock_out'] ?? '- '),
        const SizedBox(height: 30),
        _locationabsence(),
        const SizedBox(height: 30),
        _buildActivity(),
      ],
    );
  }

  // Widget untuk menampilkan Clock In/Out
  Widget _buildClockInOut(String title, String time) {
    return Container(
      width: 353,
      height: 57,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 353,
              height: 57,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                shadows: [
                  BoxShadow(
                    color: const Color(0x3F000000),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 25,
            top: 10,
            child: Icon(
              title == 'Clock In' ? Icons.history : Icons.update,
              color: Colors.black,
              size: 40.0,
            ),
          ),
          Positioned(
            left: 93,
            top: 20,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            left: 258,
            top: 20,
            child: Text(
              time,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF0A750E),
                fontSize: 14,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

    Widget _locationabsence() {
    return Container(
      width: 353,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        shadows: [
          BoxShadow(
            color: const Color(0x3F000000),
            blurRadius: 4,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Urbanist',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _reportData!['absence']['location'] ?? 'No Location Found',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Urbanist',
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan aktivitas
  Widget _buildActivity() {
    return Container(
      width: 353,
      height: 266,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        shadows: [
          BoxShadow(
            color: const Color(0x3F000000),
            blurRadius: 4,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Activity',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildActivityRow('Title:', _reportData!['activity_title'] ?? 'No Title Found'),
            const SizedBox(height: 12),
            _buildActivityRow('Description:', _reportData!['activity_description'] ?? 'No Content Found'),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  // Format waktu
  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime); // Format jam:menit
  }

  // Format tanggal
  String _formatDate(DateTime dateTime) {
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
}
