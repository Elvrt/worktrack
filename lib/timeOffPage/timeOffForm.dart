import 'package:flutter/material.dart';
import 'timeOffInfo.dart'; // Mengimpor file timeOffInfo.dart untuk navigasi
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart'; // Mengimpor Dio untuk HTTP request
import 'dart:io';

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

  // Fungsi untuk mengirim data ke API
  Future<void> _submitData(BuildContext context) async {
    try {
      Dio dio = Dio();
      String reason = "Alasan cuti"; // Ambil data alasan cuti dari field
      String startDate = "2024-11-11"; // Ambil data tanggal mulai dari field
      String endDate = "2024-11-12"; // Ambil data tanggal selesai dari field
      String fileName = ""; // Path file
      if (fileName.isNotEmpty) {
        File file = File(fileName);
        MultipartFile fileToSend = await MultipartFile.fromFile(file.path, filename: fileName);
        FormData formData = FormData.fromMap({
          'reason': reason,
          'start_date': startDate,
          'end_date': endDate,
          'letter': fileToSend,
        });

        var response = await dio.post(
          'http://10.0.2.2:8000/api/timeoff/', 
          data: formData,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data successfully submitted')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit data')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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
                  const SizedBox(height: 20),
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
                  const CustomTextField(label: '', isDateField: false), // Kolom input untuk alasan
                  const SizedBox(height: 5),
                  // Label untuk kolom 'Tanggal Cuti'
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(right: 240, bottom: 5.0),
                    child: const Text(
                      'Start Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const CustomTextField(label: '', isDateField: true), // Kolom input untuk tanggal mulai
                  const SizedBox(height: 5),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(right: 250, bottom: 5.0),
                    child: const Text(
                      'End Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const CustomTextField(label: '', isDateField: true), // Kolom input untuk tanggal selesai
                  const SizedBox(height: 5),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(right: 90, bottom: 5.0),
                    child: const Text(
                      'Leave Permission Letter (.pdf)',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const CustomTextField(label: '', isFileField: true), // Kolom input untuk surat izin
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          BottomButton(
            onPressed: () => _submitData(context), // Memanggil fungsi _submitData saat tombol ditekan
          ),
        ],
      ),
    );
  }
}

// Widget untuk kolom input kustom
class CustomTextField extends StatefulWidget {
  final String label;
  final bool isDateField;
  final bool isFileField; // Tambahkan parameter untuk menentukan apakah ini adalah field file

  const CustomTextField({
    super.key, 
    required this.label, 
    this.isDateField = false, 
    this.isFileField = false, // Inisialisasi isFileField sebagai false secara default
  });

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
    );
    if (pickedDate != null) {
      setState(() {
        _controller.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format tanggal
      });
    }
  }

  // Fungsi untuk memilih file
  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Hanya mengizinkan file PDF
    );

    if (result != null) {
      setState(() {
        _controller.text = result.files.single.name; // Menampilkan nama file yang dipilih
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
        readOnly: widget.isFileField, // Jika dateField atau fileField, kolom tidak bisa diedit
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
              : widget.isFileField
                  ? IconButton(
                      icon: const Icon(Icons.attach_file), // Ikon pemilih file
                      onPressed: () {
                        _selectFile(); // Memanggil fungsi pemilih file
                      },
                    )
                  : null,
        ),
        keyboardType: widget.isDateField ? TextInputType.datetime : TextInputType.text,
      ),
    );
  }
}

// Widget untuk tombol di bagian bawah
class BottomButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BottomButton({super.key, required this.onPressed});

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
              // Mengirim data ke API lokal 
              _submitData(context);
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
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
