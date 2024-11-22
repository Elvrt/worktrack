import 'dart:convert'; // Untuk konversi JSON
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:worktrack/navbar.dart';
import 'package:worktrack/profil/infoprofile.dart';
import 'package:worktrack/login.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController profileController = TextEditingController();

  String? errorMessage;

  // Fungsi untuk mendapatkan data profil dari API
  Future<void> fetchProfile() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        '${urlDomain}api/employee/show', // Endpoint API show
        options: Options(
          headers: {
            'Authorization':
                'Bearer $authToken', // Ganti dengan token autentikasi Anda
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        setState(() {
          nameController.text = data['employee']['name'] ?? '';
          phoneController.text = data['employee']['phone_number'] ?? '';
          dateController.text = data['employee']['date_of_birth'] ?? '';
          usernameController.text = data['user']['username'] ?? '';
          addressController.text = data['employee']['address'] ?? '';
          positionController.text = data['role']['position'] ?? '';
          numberController.text = data['employee']['employee_number'] ?? '';
          profileController.text = data['employee']['profile'] ?? '';
        });
      } else {
        setState(() {
          errorMessage = "Failed to fetch profile data.";
        });
      }
    } on DioError catch (e) {
      setState(() {
        errorMessage =
            e.response?.data['message'] ?? "An unexpected error occurred.";
      });
    }
  }

  // Fungsi untuk mengupdate data ke API
  Future<void> updateProfile() async {
    try {
      final dio = Dio();
      final data = {
        'name': nameController.text,
        'date_of_birth': dateController.text,
        'phone_number': phoneController.text,
        'address': addressController.text,
        'username': usernameController.text,
      };

      final response = await dio.post(
        '${urlDomain}api/employee/update', // Endpoint API update
        options: Options(
          headers: {
            'Authorization':
                'Bearer $authToken', // Ganti dengan token autentikasi Anda
          },
        ),
        data: jsonEncode(data),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );

        // Kembali ke halaman InfoProfile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InfoProfile()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Failed to update profile: ${response.data['message']}'),
          ),
        );
      }
    } on DioError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'An error occurred: ${e.response?.data['message'] ?? e.message}'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfile(); // Memuat data profil dari API
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: profileController.text.isNotEmpty &&
                          Uri.tryParse(profileController.text)
                                  ?.hasAbsolutePath ==
                              true
                      ? Image.network(
                          profileController.text,
                          height: 94,
                          width: 94,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 94,
                          width: 94,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                        ),
                ),
                _buildField('Name', nameController),
                _buildField('Phone Number', phoneController),
                _buildField('Date of Birth', dateController,
                    enabled: true, hasIcon: true, isDate: true),
                _buildField('Username', usernameController),
                _buildField('Address', addressController),
                _buildField('Position', positionController,
                    enabled: false, hasIcon: false),
                _buildField('Employee Identification Number', numberController,
                    enabled: false, hasIcon: false),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => showConfirmModal(
                          context), // Menampilkan modal konfirmasi
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF37AD46),
                      ),
                      child: Text(
                        'Confirm',
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InfoProfile()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE9433F),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(currentIndex: 2),
      ),
    );
  }

  // Widget field input
  Widget _buildField(String label, TextEditingController controller,
      {bool enabled = true, bool hasIcon = true, bool isDate = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        TextFormField(
          controller: controller,
          readOnly: !enabled ||
              isDate, // Nonaktifkan input manual jika tidak bisa diedit atau jika isDate
          onTap: isDate
              ? () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: controller.text.isNotEmpty
                        ? DateTime.parse(controller.text)
                        : DateTime.now(),
                    firstDate: DateTime(1900), // Atur batas bawah tanggal
                    lastDate: DateTime(2100), // Atur batas atas tanggal
                  );
                  if (pickedDate != null) {
                    setState(() {
                      controller.text =
                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}"; // Format YYYY-MM-DD
                    });
                  }
                }
              : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            filled: true,
            fillColor: Color(0xFFFFFFFF),
            suffixIcon: hasIcon
                ? Icon(isDate ? Icons.calendar_today : Icons.edit,
                    color: Colors.black)
                : null,
          ),
          style: enabled
              ? TextStyle(color: Colors.black)
              : TextStyle(color: Colors.black), // Gaya tetap seragam
        ),
        SizedBox(height: 16),
      ],
    );
  }

  // Fungsi untuk menampilkan modal konfirmasi
  void showConfirmModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Your Change',
          ),
          content: SizedBox(height: 20),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    updateProfile();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InfoProfile()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF37AD46),
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE9433F),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
