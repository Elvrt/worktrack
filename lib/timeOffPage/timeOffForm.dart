import 'package:flutter/material.dart';
import 'package:worktrack/timeOffPage/timeOffInfo.dart'; // Mengimpor file timeOffInfo.dart untuk navigasi
import 'package:worktrack/homepage/home_screen.dart';

void main() {
  runApp(const timeOff()); // Menjalankan aplikasi dengan widget timeOff
}

// Widget utama untuk aplikasi
class timeOff extends StatelessWidget {
  const timeOff({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const TimeOffScreen(), // Mengatur layar utama aplikasi
    );
  }
}

// Layar untuk mengisi formulir waktu cuti
class TimeOffScreen extends StatelessWidget {
  const TimeOffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // ukuran layar tetap
      body: Stack(
        children: [
          // Tombol untuk kembali ke layar sebelumnya
          Positioned(
            top: 70,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back), // Ikon panah kembali
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => timeOffInfo()), // Navigasi ke timeOffInfo
                );
              },
            ),
          ),
          // Menampilkan waktu dan tanggal di sudut kanan atas
          Positioned(
            top: 70,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  '08:55',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'Wednesday, Feb 11',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          // Konten utama formulir waktu cuti
          Center(
            child: SingleChildScrollView( // Mengizinkan konten untuk digulir
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Time Off Form', // Judul formulir
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Label untuk kolom 'Alasan'
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(right: 260, bottom: 5.0),
                    child: const Text(
                      'Reason',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const CustomTextField(label: ''), // Kolom input untuk alasan
                  const SizedBox(height: 5),
                  // Label untuk kolom 'Tanggal Cuti'
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(right: 170, bottom: 5.0),
                    child: const Text(
                      'Date of Work Leave',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const CustomTextField(label: '', isDateField: true), // Kolom input untuk tanggal
                  const SizedBox(height: 5),
                  // Label untuk kolom 'Surat Izin Cuti (.pdf)'
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(right: 100, bottom: 5.0),
                    child: const Text(
                      'Leave Permission Letter (.pdf)',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const CustomTextField(label: ''), // Kolom input untuk surat izin
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
          const BottomButton(), // Menampilkan tombol di bagian bawah
        ],
      ),
    );
  }
}

// Widget untuk kolom input kustom
class CustomTextField extends StatefulWidget {
  final String label;
  final bool isDateField;

  const CustomTextField({super.key, required this.label, this.isDateField = false});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TextEditingController _controller = TextEditingController(); // Kontroler untuk kolom teks

  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Tanggal awal adalah tanggal sekarang
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: const Color.fromARGB(255, 253, 222, 41), // Warna tema untuk dialog
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!, // Mengembalikan child yang dibangun
        );
      },
    );
    // Jika tanggal dipilih, set nilai kolom teks
    if (pickedDate != null) {
      setState(() {
        _controller.text = "${pickedDate.toLocal()}".split(' ')[0]; // Mengatur teks kolom
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 45,
      child: TextField(
        controller: _controller,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Inter',
        ),
        readOnly: false, // Biarkan kolom teks dapat diedit
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15), // Sudut border
          ),
          labelText: widget.label, // Label kolom teks
          hintText: 'Input here', // Teks petunjuk
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontFamily: 'Inter',
          ),
          suffixIcon: widget.isDateField
              ? IconButton(
                  icon: const Icon(Icons.calendar_month), // Ikon pemilih tanggal
                  onPressed: () {
                    _selectDate(context); // Memanggil fungsi pemilih tanggal
                  },
                )
              : null,
        ),
        keyboardType: widget.isDateField ? TextInputType.datetime : TextInputType.text, // Tipe input untuk tanggal
      ),
    );
  }
}

// Widget untuk tombol di bagian bawah
class BottomButton extends StatelessWidget {
  const BottomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100.0), // Jarak dari bawah
        child: SizedBox(
          width: 320,
          height: 45,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => timeOffInfo()),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 246, 214, 71), // Warna latar belakang tombol
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Sudut tombol
              ),
            ),
            child: const Text(
              'Apply', // Teks pada tombol
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
      ),
    );
  }
}