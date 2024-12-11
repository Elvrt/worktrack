import 'package:flutter/material.dart';
import 'timeOffInfo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:worktrack/login.dart';

class timeOff extends StatefulWidget {
  const timeOff({super.key});

  @override
  _TimeOffScreenState createState() => _TimeOffScreenState();
}

class _TimeOffScreenState extends State<timeOff> {
  // Controllers untuk form input
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController fileController = TextEditingController();

  String? errorMessage;
  String? selectedFilePath;

  // Fungsi untuk mengirim data time off
Future<void> submitTimeOff() async {
    try {
      final dio = Dio();
      dio.options.headers["Authorization"] = "Bearer $authToken"; // Auth token

      // Data yang akan dikirim
      FormData formData = FormData.fromMap({
        'reason': reasonController.text,
        'start_date': startDateController.text,
        'end_date': endDateController.text,
      });

      // Tambahkan file jika ada
      if (selectedFilePath != null && selectedFilePath!.isNotEmpty) {
        final file = File(selectedFilePath!);
        formData.files.add(MapEntry(
          'letter',
          await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
        ));
      }

      // Kirim data ke API
     final response = await dio.post(
      '${urlDomain}api/timeoff/store/',
      data: formData,
    );

      if (response.statusCode == 200) {
      print('Success: ${response.data}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data successfully submitted')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => timeOffInfo()),
      );
    } else {
      print('Failed: ${response.data}');
      setState(() {
        errorMessage = 'Failed to submit data: ${response.data['message']}';
      });
    }
  } catch (e) {
    print('Error: $e');
    setState(() {
      errorMessage = 'Error occurred: $e';
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 70,
            left: 20,
             child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => timeOffInfo()),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Time Off Form',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      letterSpacing: 4,
                    ),
                    
                  ),const SizedBox(height: 30),
                   _buildInputLabel('Reason', 260),
                  CustomTextField(controller: reasonController),
                  const SizedBox(height: 5),
                  _buildInputLabel('Start Date', 240),
                  CustomTextField(controller: startDateController, isDateField: true),
                  const SizedBox(height: 5),
                  _buildInputLabel('End Date', 250),
                  CustomTextField(controller: endDateController, isDateField: true),
                  const SizedBox(height: 5),
                  _buildInputLabel('Leave Permission Letter (img)', 90),
                  CustomTextField(
                    controller: fileController,
                    isFileField: true,
                    selectedFilePath: (filePath) {
                      setState(() {
                        selectedFilePath = filePath;
                      });
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          BottomButton(onPressed: submitTimeOff),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String text, double rightPadding) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: rightPadding, bottom: 5.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontFamily: 'Inter'),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isDateField;
  final bool isFileField;
  final Function(String)? selectedFilePath;

  const CustomTextField({
    super.key,
    required this.controller,
    this.isDateField = false,
    this.isFileField = false,
    this.selectedFilePath,
  });

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      controller.text = "${pickedDate.toLocal()}".split(' ')[0];
    }
  }

Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );
    if (result != null) {
      String filePath = result.files.single.path!;
      String fileName = result.files.single.name;
      controller.text = fileName;
      if (selectedFilePath != null) {
        selectedFilePath!(filePath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 45,
      child: TextField(
        controller: controller,
        readOnly: isDateField || isFileField,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: 'Input here',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Inter'),
          suffixIcon: isDateField
              ? IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () => _selectDate(context),
                )
              : isFileField
                  ? IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: _selectFile,
                    )
                  : null,
        ),
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BottomButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: SizedBox(
          width: 320,
          height: 45,
          child: TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 246, 214, 71),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Apply',
              style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Inter'),
            ),
          ),
        ),
      ),
    );
  }
}
