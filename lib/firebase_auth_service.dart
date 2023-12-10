import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService with ChangeNotifier {
  final FirebaseAuth _authService = FirebaseAuth.instance;

  Stream<String?> get onAuthStateChanged =>
      _authService.authStateChanges().map((user) => user?.uid);

  Future<String?> getCurrentUID() async {
    try {
      return (await _authService.currentUser)?.uid;
    } catch (e) {
      print("Error getting UID: $e");
      return null;
    }
  }

  Future<User?> getCurrentUser() async {
    return _authService.currentUser;
  }

  Future<User?> signUpWithEmailandPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await _authService
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = credential.user;
      // Memberitahu listener bahwa ada perubahan pada objek
      notifyListeners();
      return user;
    } catch (e) {
      final String errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ));
      throw e;
    }
  }

  Future<void> updateUserName(String newName) async {
    try {
      await _authService.currentUser?.updateDisplayName(newName);
      notifyListeners();
    } catch (e) {
      print("Error updating user name: $e");
      throw e;
    }
  }

  Future<User?> loginWithEmailandPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await _authService.signInWithEmailAndPassword(
          email: email, password: password);
      final user = credential.user;
      // Memberitahu listener bahwa ada perubahan pada objek
      notifyListeners();
      return user;
    } catch (e) {
      final String errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ));
      throw e;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    // Memberitahu listener bahwa ada perubahan pada objek
    notifyListeners();
  }
}
