import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EnrollmentDetailScreen extends StatefulWidget {
  final String uid;

  const EnrollmentDetailScreen({required this.uid, Key? key}) : super(key: key);

  @override
  State<EnrollmentDetailScreen> createState() => _EnrollmentDetailScreenState();
}

class _EnrollmentDetailScreenState extends State<EnrollmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enrollment Details'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('student')
            .doc(widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var studentData = snapshot.data!.data();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${studentData!['name']}'),
                SizedBox(height: 10),
                Text('Roll No: ${studentData['rollno']}'),
                SizedBox(height: 10),
                Text('Semester: ${studentData['semester']}'),
                SizedBox(height: 10),
                Text('Department: ${studentData['department']}'),
                // You can add more details here
              ],
            ),
          );
        },
      ),
    );
  }
}
