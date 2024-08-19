import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  final adminEmail = TextEditingController();
  final userEmail = TextEditingController();

  final adminPass = TextEditingController();
  final userPass = TextEditingController();
  final name = TextEditingController();
  final firestore = FirebaseFirestore.instance;
}
