import 'package:flutter/material.dart';
import 'package:flutter_firebase/firebase_auth_service.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Simpan perubahan ke Firebase atau penyimpanan data lainnya
                _saveChanges(context);
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveChanges(BuildContext context) async {
    try {
      await Provider.of<FirebaseAuthService>(context, listen: false)
          .updateUserName(_nameController.text);
      // Kembali ke halaman profil setelah menyimpan perubahan
      Navigator.of(context).pop();
    } catch (e) {
      print("Error updating user name: $e");
      // Tampilkan pesan kesalahan jika perlu
    }
  }
}
