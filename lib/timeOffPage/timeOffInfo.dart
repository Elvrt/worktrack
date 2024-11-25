import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'timeOffForm.dart';
import 'package:worktrack/homepage/home_screen.dart';
import 'package:worktrack/login.dart'; // Untuk akses authToken
import 'timeOffDetail.dart';
import 'package:intl/intl.dart';

class timeOffInfo extends StatefulWidget {
  const timeOffInfo({super.key});

  @override
  _TimeOffScreenState createState() => _TimeOffScreenState();
}

class _TimeOffScreenState extends State<timeOffInfo> {
  List<Map<String, String>> requests = [];
  final String apiUrl = "${urlDomain}api/timeoff/";
  final Dio _dio = Dio();
  int currentPage = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    fetchRequests(currentPage);
  }

  Future<void> fetchRequests(int page) async {
    try {
      // Tambahkan token ke header
      final options = Options(
        headers: {
          'Authorization': 'Bearer $authToken', // Gunakan token dari login.dart
        },
      );

      // Memuat data dari API dengan parameter halaman dan limit
      Response response = await _dio.get(
        apiUrl,
        queryParameters: {'page': page, 'limit': 5},
        options: options,
      );

      // Cek format data apakah sesuai dengan yang diharapkan
      var decodedData =
          response.data is String ? jsonDecode(response.data) : response.data;
      print("Fetching page: $page");
      print("Response data: $decodedData");

      if (decodedData is Map && decodedData.containsKey('data')) {
        List<dynamic> data = decodedData['data'];

        setState(() {
          // Tampilkan hanya data dari halaman saat ini
          requests = data.map((item) => {
                    'no_request': item['time_off_id'].toString(),
                    'workLeave': '${item['start_date']} - ${item['end_date']}',
                    'status': item['status'].toString(),
                    'employee_id' : item ['employee_id'].toString(),
                    'employee_name': item['employee']['name'].toString(), // Ambil nama karyawan
                    'reason' : item['reason'].toString(),
                    'letter' : item['letter'].toString()
                    
                  })
              .toList();

          // Perbarui kondisi isLastPage berdasarkan jumlah item di halaman
          isLastPage = data.length <
              5; // Jika data kurang dari limit, artinya halaman terakhir
          print("Is last page: $isLastPage");
        });
      } else {
        print('Unexpected data format. Expected Map with "data" key.');
      }
    } catch (e) {
      print('Error fetching requests: $e');
    }
  }

    // Format waktu
  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime); // Format jam:menit
  }

  // Format tanggal
  String _formatDate(DateTime dateTime) {
    return DateFormat('EEEE, MMM dd').format(dateTime); // Contoh: Wednesday, Feb 11
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


  void _navigateToTimeOffDetail(Map<String, String> request) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TimeOffDetail( timeOffRequest: request),
      ),
    );
  }

  void _navigateToTimeOff() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const timeOff()),
    );
  }

  void _loadNextPage() {
    if (!isLastPage) {
      setState(() {
        currentPage++;
        fetchRequests(currentPage);
      });
    }
  }

  void _loadPreviousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
        fetchRequests(currentPage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 70,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreenPage()),
                );
              },
            ),
          ),
          Positioned(
            top: 70,
            right: 20,
            child: _buildLiveTimeAndDate(), //time otomatis
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 130),
                  const Text(
                    'Time Off Info',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(0),
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
                      border: TableBorder.all(color: Colors.transparent),
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1)
                      },
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 235, 168),
                          ),
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'No Request',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Date of Work Leave',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Status',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                           Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Detail',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ...requests.map((request) {
                          return TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  request['no_request'] ?? '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  request['workLeave'] ?? '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  request['status'] ?? '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  iconSize: 24,
                                  onPressed: () {
                                    _navigateToTimeOffDetail(request);
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: currentPage > 1 ? _loadPreviousPage : null,
                        child: const Text('Previous'),
                      ),
                      ElevatedButton(
                        onPressed: !isLastPage ? _loadNextPage : null,
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: _navigateToTimeOff,
                      backgroundColor: const Color(0xFFF6D647),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
