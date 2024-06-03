import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<User?> registerWithEmailAndPassword(String email, String password, String username) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;

      // Store UID and username in Firestore
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
        });
      }

      return user;
    } catch (e) {
      log("Failed to create user: $e");
      return null;
    }
  }

  // Register with phone number and password
  Future<User?> registerWithPhoneNumberAndPassword(String phoneNumber, String password, String username) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: '$phoneNumber@smitube.com', password: password,);
      final User? user = userCredential.user;

      // Set username as UID
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
        });
      }

      return user;
    } catch (e) {
      log("Failed to register with phone number: $e");
    }
    return null;
  }

  // Login with email or phone number and password
  Future<User?> login(String emailOrPhoneNumber, String password) async {
    try {
      UserCredential userCredential;
      if (emailOrPhoneNumber.contains('@')) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: emailOrPhoneNumber,
          password: password,
        );
      } else {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: '$emailOrPhoneNumber@smitube.com', // Create a dummy email
          password: password,
        );
      }
      return userCredential.user;
    } catch (e) {
      log("Failed to login: $e");
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Failed to sign out: $e");
    }
  }
}
