import 'package:flutter/material.dart';
import 'package:worktrack/timeOffPage/timeOffForm.dart'; // Import widget TimeOff
import 'package:worktrack/homepage/home_screen.dart';

void main() {
  runApp(MaterialApp(
    home: const timeOffInfo(),
  ));
}

class timeOffInfo extends StatefulWidget {
  const timeOffInfo({super.key});

  @override
  _TimeOffScreenState createState() => _TimeOffScreenState();
}

class _TimeOffScreenState extends State<timeOffInfo> {
  List<Map<String, String>> requests = [
    {
      'dateRequest': '1', // Data permintaan cuti
      'workLeave': '12 - 13, Feb 2024', // Tanggal cuti kerja
      'status': 'Pending', // Status permintaan
    },
  ];

  // Fungsi untuk navigasi ke halaman TimeOff
  void _navigateToTimeOff() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const timeOff()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( // Stack digunakan untuk menumpuk beberapa elemen
        children: [
          // Tombol kembali di pojok kiri atas
          Positioned(
            top: 70,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back), // Ikon panah kiri
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
          ),
          // Menampilkan waktu di pojok kanan atas
          Positioned(
            top: 70,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  '08:55', // Menampilkan jam
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'Wednesday, Feb 11', // Menampilkan tanggal
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          // Form di bagian tengah
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 130), // Jarak antara atas dengan judul
                  const Text(
                    'Time Off Info', // Judul form
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 40), // Jarak antara judul dan tabel

                  // Kontainer tabel dengan dekorasi
                  
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Warna latar putih
                      borderRadius: BorderRadius.circular(0), // Membulatkan sudut kontainer
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26, // Bayangan kontainer
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),

                    margin:  EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    // Tabel untuk menampilkan data permintaan cuti
                    child: Table(
                      border: TableBorder(
                        horizontalInside: BorderSide(color: Colors.transparent),
                        verticalInside: BorderSide(color: Colors.transparent),
                        top: BorderSide(color: Colors.transparent),
                        bottom: BorderSide(color: Colors.transparent),
                        left: BorderSide(color: Colors.transparent),
                        right: BorderSide(color: Colors.transparent),
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(1),
                      },
                      children: [
                        // Baris header tabel
                        TableRow(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 235, 168), // Latar belakang kuning pada header
                          ),
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'No Request', // Header kolom Date Request
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
                                'Date of Work Leave', // Header kolom Date of Work Leave
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
                                'Status', // Header kolom Status
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  ),
                              ),
                            ),
                          ],
                        ),
                        // Menampilkan data permintaan cuti dari list `requests`
                        ...requests.map((request) {
                          return TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  request['dateRequest'] ?? '',
                                  textAlign: TextAlign.center,
                                   style: TextStyle(
                                      fontSize: 12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  request['workLeave'] ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                  ),
                                  
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  request['status'] ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 250), // Jarak antara tabel dan tombol tambah
                  // Tombol tambah di pojok kanan bawah
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: _navigateToTimeOff, // Navigasi ke halaman TimeOff
                      backgroundColor: const Color(0xFFF6D647),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40), // Membulatkan sudut tombol
                      ),
                      child: const Icon(Icons.add), // Ikon tambah
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

