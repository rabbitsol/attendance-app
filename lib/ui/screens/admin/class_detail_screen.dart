import 'package:face_recognition_attendance_app/model/appIcons.dart';
import 'package:face_recognition_attendance_app/model/appcolors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClassDetailScreen extends StatefulWidget {
  const ClassDetailScreen({Key? key}) : super(key: key);

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color.fromARGB(255, 216, 227, 241),
              // .withOpacity(0.1),
              Color(0xFFFFFFFF)
              // .withOpacity(0.05),
            ],
                stops: [
              0.1,
              1,
            ])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: LayoutBuilder(builder: (context, constraints) {
              final isWeb = kIsWeb && constraints.maxWidth > 600;
              if (!isWeb) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 45),
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          AppIcons.classId,
                          height: 100,
                          width: 100,
                        ),
                      ),
                      const SizedBox(height: 45),
                      const Text(
                        'Class Details',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 35,
                        ),
                      ),
                      const SizedBox(height: 30),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
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

                          final users = snapshot.data!.docs;

                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final userData = users[index].data();

                              return Column(
                                children: [
                                  Card(
                                    elevation: 5,
                                    child: ListTile(
                                      title: Text('Name: ${userData['name']}'),
                                      subtitle:
                                          Text('Email: ${userData['email']}'),
                                      onTap: () {
                                        _showUserDetailDialog(
                                            context, userData, users[index].id);
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              } else {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 45),
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          AppIcons.classId,
                          height: 100,
                          width: 100,
                        ),
                      ),
                      const SizedBox(height: 45),
                      const Text(
                        'Class Details',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 35,
                        ),
                      ),
                      const SizedBox(height: 30),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
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

                          final users = snapshot.data!.docs;

                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final userData = users[index].data();

                              return Column(
                                children: [
                                  Card(
                                    elevation: 5,
                                    child: ListTile(
                                      title: Text('Name: ${userData['name']}'),
                                      subtitle:
                                          Text('Email: ${userData['email']}'),
                                      onTap: () {
                                        _showUserDetailDialog(
                                            context, userData, users[index].id);
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  // ),
                );
              }
            }),
          ),
        ));
  }

  void _showUserDetailDialog(
      BuildContext context, Map<String, dynamic> userData, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.black,
          elevation: 10,
          title: const Text(
            'User Detail',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 28,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Name: ${userData['name']}',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                ),
              ),
              Text(
                'Email: ${userData['email']}',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                ),
              ),
              // Fetch and display student information
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('student')
                    .doc(userId)
                    .snapshots(),
                builder: (context, studentSnapshot) {
                  if (studentSnapshot.hasError) {
                    return Text('Error: ${studentSnapshot.error}');
                  }

                  if (!studentSnapshot.hasData) {
                    return const SizedBox
                        .shrink(); // No student data for this user
                  }

                  var studentData = studentSnapshot.data!.data();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Roll No: ${studentData?['rollno'] ?? 'N/A'}',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Semester: ${studentData?['semester'] ?? 'N/A'}',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Department: ${studentData?['department'] ?? 'N/A'}',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                        ),
                      ),
                      // Add more fields as needed
                    ],
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: AppColors.aqua,
                  fontSize: 28,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
