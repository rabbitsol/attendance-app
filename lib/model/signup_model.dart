import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_recognition_attendance_app/ui/screens/auth/signin_screen.dart';
import 'package:face_recognition_attendance_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

signUpUser(
  BuildContext context,
  String userName,
  String userPhone,
  String userEmail,
  String userPassword,
  String role,
) async {
  User? userid = FirebaseAuth.instance.currentUser;
  if (role == 'Admin') {
    final adminSnapshot = await FirebaseFirestore.instance
        .collection('admins')
        .doc('admin')
        .get();
    if (adminSnapshot.exists) {
      // Admin already created, show an error message or prevent signup
      return Utils.toastMessage("Admin already created");
    }
  }
  try {
    await FirebaseFirestore.instance.collection("user").doc(userid!.uid).set({
      'userName': userName,
      'userPhone': userPhone,
      'userEmail': userEmail,
      'userPassword': userPassword,
      'userRole': role,
      'createdAt': DateTime.now(),
      'userId': userid.uid,
    }).then((value) => {
          FirebaseAuth.instance.signOut(),
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const SignInScreen()))
        });
  } on FirebaseAuthException catch (e) {
    print("Error $e");
  }
}
