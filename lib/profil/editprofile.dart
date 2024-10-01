import 'package:flutter/material.dart';

void main() {
  runApp(EditProfile());
}

class EditProfile extends StatelessWidget {
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
        bottomNavigationBar: BottomNavBar(),
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
            SizedBox(height: 8),
            Text(
              'Change your picture',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            SizedBox(height: 20),

            _buildField('Name', nameController),
            _buildField('Phone Number', phoneController),
            _buildField('Date of Birth', dateController),
            _buildField('Username', usernameController),
            _buildField('Address', addressController),

            // Field untuk Position dan Number yang dinonaktifkan
            _buildField('Position', positionController,
                enabled: false, hasIcon: false),
            _buildField('Employee Identification Number', numberController,
                enabled: false, hasIcon: false),

            // Tombol Confirm dan Cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Tampilkan dialog konfirmasi saat tombol Confirm ditekan
                    _showConfirmationDialog(context);
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
                  onPressed: () {},
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
            SizedBox(height: 50), // Jarak dengan BottomNavBar
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membangun TextField dengan label
  Widget _buildField(String label, TextEditingController controller,
      {bool enabled = true, bool hasIcon = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas TextField
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 16, color: Colors.black), // Warna label menjadi hitam
          ),
        ),
        // TextField dengan atau tanpa ikon pensil di sebelah kanan
        Container(
          width: 350,
          child: TextField(
            controller: controller,
            enabled: enabled, // Mengatur apakah field bisa diinput atau tidak
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
              fillColor: Colors.white, // Background TextField putih
              suffixIcon: hasIcon
                  ? Icon(Icons.edit, color: Colors.black)
                  : null, // Ikon pensil di sebelah kanan
            ),
            style: TextStyle(
                color:
                    Colors.black), // Warna teks dalam TextField menjadi hitam
          ),
        ),
        SizedBox(height: 16), // Jarak antar field
      ],
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi
  void _showConfirmationDialog(BuildContext context) {
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
                    Navigator.of(context).pop(); // Tutup dialog
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
                    Navigator.of(context).pop(); // Tutup dialog
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

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.assessment),
          label: 'Report',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      unselectedItemColor: Color(0xFF9E9E9E),
      selectedItemColor: Color(0xFFFEDB47),
      currentIndex: 0, // Set initial index
      onTap: (int index) {
        // Handle tab change
      },
    );
  }
}
