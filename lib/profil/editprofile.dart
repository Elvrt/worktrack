import 'package:flutter/material.dart';

void main() {
  runApp(EditProfile());
}

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          
        ),
        body: FormScreen(),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}

class FormScreen extends StatelessWidget {
  // Membuat TextEditingController untuk setiap field
  final TextEditingController namaController = TextEditingController(text: 'Nafiul Alam Dary Vega');
  final TextEditingController noTelpController = TextEditingController(text: '081234567890');
  final TextEditingController ttlController = TextEditingController(text: '17/Agustus/1945');
  final TextEditingController usernameController = TextEditingController(text: 'nafiulvega');
  final TextEditingController passwordController = TextEditingController(text: 'Jl. Melati No.21, Mojokerto, Jawa Timur');
  final TextEditingController alamatController = TextEditingController(text: 'Eselon2');
  final TextEditingController jabatanController = TextEditingController(text: '1234567890');
  final TextEditingController einController = TextEditingController(text: '1234567890');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Gambar di tengah dengan border radius
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0), // Border radius pada gambar
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

            _buildField('Nama', namaController),
            _buildField('No Telepon', noTelpController),
            _buildField('Tanggal Lahir', ttlController),
            _buildField('Username', usernameController),
            _buildField('Password', passwordController),
            _buildField('Alamat', alamatController),
            _buildField('Jabatan', jabatanController),
            _buildField('Employee Identification Number', einController),

            // Tombol Confirm dan Cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF37AD46),
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white),
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
                    style: TextStyle(color: Colors.white),
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
  Widget _buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas TextField
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.black), // Warna label menjadi hitam
          ),
        ),
        // TextField dengan ikon pensil di sebelah kanan
        Container(
          width: 350,
          child: TextField(
            controller: controller,
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
              suffixIcon: Icon(Icons.edit, color: Colors.black), // Ikon pensil di sebelah kanan
            ),
            style: TextStyle(color: Colors.black), // Warna teks dalam TextField menjadi hitam
          ),
        ),
        SizedBox(height: 16), // Jarak antar field
      ],
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
