import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const TimeOffScreen(), // layar utama 
    );
  }
}

class TimeOffScreen extends StatelessWidget {
  const TimeOffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( // Menggunakan Stack untuk menumpuk beberapa elemen di layar
        children: [
          // Tombol kembali di pojok kiri atas
          Positioned(
            top: 50, //  posisi vertikal tombol
            left: 20, // posisi horizontal tombol
            child: IconButton(
              icon: const Icon(Icons.arrow_back), // Menampilkan ikon panah kiri
              onPressed: () {
                // Fungsi ketika tombol kembali ditekan
              },
            ),
          ),
          // Tanggal dan waktu di pojok kanan atas
          Positioned(
            top: 50, // posisi vertikal teks waktu
            right: 20, // posisi horizontal teks waktu
            child: Column( // tampilan teks waktu dalam kolom
              crossAxisAlignment: CrossAxisAlignment.end, // teks di sebelah kanan
              children: const [
                Text(
                  '08:55', // Menampilkan waktu
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold, // Menambahkan tebal pada teks
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 1), // Jarak antara waktu dan tanggal
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
          // Konten form di bagian tengah
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Menambahkan jarak di samping form
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Posisikan kolom di tengah secara vertikal
                children: [
                  const Text(
                    'Time Off Form', // Judul form
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold, // Teks judul dengan huruf tebal
                      fontFamily: 'Inter',
                      letterSpacing: 4
                    ),
                  ),
                  const SizedBox(height:30), // Jarak antara judul dan kolom form
                  
                  // Judul di atas field Reason
                   Container(
                      alignment: Alignment.center, // Menyelaraskan teks di kiri dalam container
                      padding: const EdgeInsets.only(right: 220, bottom: 5.0), // Menambahkan padding
                    child: Text(
                      'Reason', // Judul field Reason
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal, // Gaya teks normal
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  CustomTextField(label: ''), // Field alasan cuti
                  const SizedBox(height: 5), // Jarak antar field

                  // Judul di atas field Date of Work Leave
                  Container(
                      alignment: Alignment.center, // Menyelaraskan teks di kiri dalam container
                      padding: const EdgeInsets.only(right: 130, bottom: 5.0), // Menambahkan padding
                    child: Text(
                      'Date of Work Leave', // Judul field Date of Work Leave
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal, // Gaya teks normal
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  CustomTextField(label: ''), // Field tanggal cuti
                  const SizedBox(height: 5), // Jarak antar field

                  // Judul di atas field Leave Permission Letter (.pdf)
                  Container(
                      alignment: Alignment.center, // Menyelaraskan teks di kiri dalam container
                      padding: const EdgeInsets.only(right: 60, bottom: 5.0), // Menambahkan padding 
                      child: Text(
                        'Leave Permission Letter (.pdf)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),

                  CustomTextField(label: ''), // Field upload surat izin
                  const SizedBox(height: 120), // Jarak antara field dan tombol Apply
                ],
              ),
            ),
          ),
          const BottomButton(), // Tombol "Apply" di bagian bawah layar
        ],
      ),
    );
  }
}

// Widget untuk input TextField dengan parameter label
class CustomTextField extends StatelessWidget {
  final String label; // Parameter label untuk tiap TextField

  const CustomTextField({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280, // Lebar TextField
      height: 40, // Tinggi TextField
      child: TextField(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16, // Ukuran font dalam TextField
          fontWeight: FontWeight.normal,
          fontFamily: 'Inter',
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15), // Membuat sudut TextField membulat
          ),
          labelText: label, // Label untuk TextField
          hintText: 'Input here', // Hint di dalam TextField sesuai label
          hintStyle: const TextStyle(
            color: Colors.grey, // Warna hint text
            fontSize: 16,
            fontWeight: FontWeight.normal,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}

// Tombol "Apply" di bagian bawah layar
class BottomButton extends StatelessWidget {
  const BottomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter, // Menempatkan tombol di bagian bawah tengah
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100.0), // Jarak antara tombol dan bawah layar
        child: SizedBox(
          width: 280, // Lebar tombol
          height: 45, // Tinggi tombol
          child: TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Button pressed')), // Tampilkan pesan ketika tombol ditekan
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 246, 214, 71), // Warna latar belakang tombol
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Membulatkan sudut tombol
              ),
            ),
            child: const Text(
              'Apply', // Teks di dalam tombol
              style: TextStyle(
                color: Colors.white, // Warna teks 
                fontSize: 16, // Ukuran font 
                fontWeight: FontWeight.bold, //  teks bold
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
