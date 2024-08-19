import 'dart:async';
import 'package:face_recognition_attendance_app/ui/screens/admin/admin_nav_screen.dart';
import 'package:face_recognition_attendance_app/ui/screens/auth/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if (user != null) {
      if (!user.isAnonymous) {
        // Check user's role here using Firestore or any other database method
        // For example, assume the user's role is stored as a field in Firestore
        // under 'users' collection and 'role' field
        // const userRole = 'Admin'; // Replace this with actual user role

        // if (userRole == 'Admin') {
        Timer(
          const Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AdminNavScreen()),
          ),
        );
      } else {
        Timer(
          const Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AdminNavScreen()),
          ),
        );
      }
    } else {
      Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        ),
      );
    }
  }
}
// }
