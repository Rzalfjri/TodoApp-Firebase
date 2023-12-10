import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/View/EditProfilePage.dart';
import 'package:flutter_firebase/View/onboarding.dart';
import 'package:flutter_firebase/View/login.dart'; // Gantilah dengan lokasi sesuai struktur proyek Anda
import 'package:provider/provider.dart';
import 'package:flutter_firebase/firebase_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyC5o5Vcn6GwKb4Vy6BruBf8zVm4aC3E-28",
        appId: "1:677929994861:android:ec47f20455ad25e053cd64",
        messagingSenderId: "677929994861",
        projectId: "todoapp-c08eb",
      ),
    );

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => FirebaseAuthService(),
          ),
          // Tambahkan provider lain jika diperlukan
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Onboarding(),
        '/Login': (context) => Login(),
        '/edit': (context) => EditProfilePage(),
        // ... definisikan rute lainnya di sini ...
      },
    );
  }
}
