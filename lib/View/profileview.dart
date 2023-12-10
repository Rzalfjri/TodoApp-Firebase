import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/firebase_auth_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profil'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/DSC_2109.JPG'),
              ),
              SizedBox(height: 16.0),
              Consumer<FirebaseAuthService>(
                builder: (context, authService, child) {
                  return FutureBuilder<User?>(
                    future: authService.getCurrentUser(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (userSnapshot.hasError) {
                        return Text("Error: ${userSnapshot.error}");
                      } else {
                        final user = userSnapshot.data;
                        return displayInformasiPengguna(context, user);
                      }
                    },
                  );
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/edit');
                },
                child: Text('Edit Profil'),
              ),
              SizedBox(height: 16.0),
              showSignOut(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayInformasiPengguna(BuildContext context, User? user) {
    if (user != null) {
      // ignore: unused_local_variable
      final userId = user.uid;

      return Column(
        children: <Widget>[
          Text(
            "Nama: ${user.displayName ?? 'Anonim'}",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 8.0),
          Text(
            "Email: ${user.email ?? 'Anonim'}",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 8.0),
          Text(
            "Dibuat: ${user.metadata.creationTime != null ? DateFormat('MM/dd/yyyy').format(user.metadata.creationTime!) : 'N/A'}",
            style: TextStyle(fontSize: 18),
          ),
        ],
      );
    } else {
      return Text("Tidak dapat mengambil informasi pengguna.");
    }
  }

  Widget showSignOut(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
      ),
      child: Text("Keluar", style: TextStyle(fontSize: 18)),
      onPressed: () {
        _showSignOutDialog(context);
      },
    );
  }

  Future<void> _showSignOutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Anda yakin ingin keluar?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Keluar'),
              onPressed: () async {
                Navigator.of(context).pop(); // Tutup dialog
                try {
                  await Provider.of<FirebaseAuthService>(context, listen: false)
                      .signOut();
                  // Kembali ke halaman login
                  Navigator.of(context).pushReplacementNamed('/Login');
                  // Perbarui tampilan profil setelah keluar
                  updateProfile(context);
                } catch (e) {
                  print("Error signing out: $e");
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateProfile(BuildContext context) async {
    // Implementasi untuk memperbarui tampilan profil jika diperlukan
  }
}
