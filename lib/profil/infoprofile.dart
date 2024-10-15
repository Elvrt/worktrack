import 'package:flutter/material.dart';
import 'package:worktrack/profil/editprofile.dart';
import 'package:worktrack/navbar.dart';

void main() {
  runApp(InfoProfile());
}

class InfoProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 71.0), // Berikan jarak 71 dari atas layar
            child: FormScreen(),
          ),
        ),
        bottomNavigationBar: BottomNavBar(currentIndex: 2),
      ),
    );
  }
}

class FormScreen extends StatelessWidget {
  // Membuat TextEditingController untuk setiap field
  final TextEditingController nameController =
      TextEditingController(text: 'Nafiul Alam Dary Vega');
  final TextEditingController phoneController =
      TextEditingController(text: '081234567890');
  final TextEditingController dateController =
      TextEditingController(text: '17/August/1945');
  final TextEditingController usernameController =
      TextEditingController(text: 'nafiulvega');
  final TextEditingController addressController =
      TextEditingController(text: 'Jl. Melati No.21, Mojokerto, Jawa Timur');
  final TextEditingController positionController =
      TextEditingController(text: 'Eselon2');
  final TextEditingController numberController =
      TextEditingController(text: '1234567890');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(), // Menambahkan physics untuk scroll halus
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Gambar di tengah dengan border radius
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(
                'https://awsimages.detik.net.id/community/media/visual/2018/06/10/82fffd14-c0d7-478b-a722-5169c8e53e39.jpeg?w=600&q=90',
                height: 94,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),

            _buildField('Name', nameController),
            _buildField('Phone Number', phoneController),
            _buildField('Date of Birth', dateController),
            _buildField('Username', usernameController),
            _buildField('Address', addressController),
            _buildField('Position', positionController,),
            _buildField('Employee Identification Number', numberController),

            // Tombol Confirm dan Cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfile()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFD83A),
                    fixedSize: Size(174, 40),
                  ),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 25), // Jarak dengan BottomNavBar
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membangun TextField dengan label
  Widget _buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas TextField
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 16, color: Colors.black),
          ),
        ),
        Container(
          width: 350,
          child: TextField(
            controller: controller,
            enabled: false, // Mengatur apakah field bisa diinput atau tidak
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: Color(0xFFD9D9D9)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: Colors.black),
              ),
              filled: true,
              fillColor: Color(0xFFFFFFFF),
            ),
            style: TextStyle(
                color:
                    Colors.black), 
          ),
        ),
        SizedBox(height: 16), // Jarak antar field
      ],
    );
  }
}
