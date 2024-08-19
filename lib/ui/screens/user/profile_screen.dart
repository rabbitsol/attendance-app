import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_recognition_attendance_app/model/appcolors.dart';
import 'package:face_recognition_attendance_app/ui/screens/auth/signin_screen.dart';
import 'package:face_recognition_attendance_app/ui/widgets/profile_card.dart';
import 'package:face_recognition_attendance_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  bool islogout = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        // color: AppColors().bgcolor,
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
            body: SingleChildScrollView(
              child: LayoutBuilder(builder: (context, constraints) {
                final isWeb = kIsWeb && constraints.maxWidth > 600;
                if (!isWeb) {
                  return ListView(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      children: [
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(currentUser!.uid)
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

                            // Here, you can access the user's data from the snapshot
                            var userData = snapshot.data!.data();
                            return Column(children: [
                              Container(
                                // margin: const EdgeInsets.only(top: 30),
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [AppColors.black, AppColors.blue],
                                    ),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(60),
                                        bottomRight: Radius.circular(60))),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 30.0, right: 30),
                                        child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 116, 154, 199),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: IconButton(
                                              icon: const Icon(Icons.logout,
                                                  color: AppColors.white),
                                              onPressed: () {
                                                FirebaseAuth.instance.signOut();
                                                setState(() {
                                                  islogout = true;
                                                });
                                                Utils.toastMessage(
                                                    'Logged Out!!!');
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: ((context) =>
                                                            const SignInScreen())));
                                              },
                                            )),
                                      ),
                                    ),
                                    StreamBuilder<
                                        DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection('student')
                                          .doc(currentUser!.uid)
                                          .snapshots(),
                                      builder: (context, studentSnapshot) {
                                        if (studentSnapshot.hasError) {
                                          return Center(
                                            child: Text(
                                                'Error: ${studentSnapshot.error}'),
                                          );
                                        }

                                        if (!studentSnapshot.hasData) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }

                                        var studentData =
                                            studentSnapshot.data!.data();
                                        String studentImageUrl =
                                            studentData?['image'] ??
                                                ''; // Get the image URL

                                        return CircleAvatar(
                                          radius: 50,
                                          backgroundImage: studentImageUrl
                                                  .isNotEmpty
                                              ? NetworkImage(studentImageUrl)
                                              : null,
                                          backgroundColor: AppColors.bgcolor,
                                        );
                                      },
                                    ),

                                    // const CircleAvatar(
                                    //   radius: 50,
                                    //   backgroundColor: AppColors.bgcolor,
                                    // ),
                                    const SizedBox(height: 30),
                                    Text(userData!['name'],
                                        style: const TextStyle(
                                            fontSize: 30,
                                            color: AppColors.white)),
                                    const SizedBox(height: 10),
                                    Text(
                                        userData['role'] == 'Admin'
                                            ? 'Admin'
                                            : 'Student',
                                        style: const TextStyle(
                                            fontSize: 24,
                                            color: AppColors.white)),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),
                              // You can display the user's data here
                              ProfileCard(
                                  iconss: Icons.email,
                                  detail: 'Email: ${userData['email']}'),
                              // const SizedBox(height: 5),
                              // ProfileCard(
                              //     iconss: Icons.person, detail: 'Name: ${userData['name']}'),
                              const SizedBox(height: 5),
                              ProfileCard(
                                  iconss: Icons.phone,
                                  detail: 'Phone: ${userData['phone']}'),
                              // ProfileCard(
                              //     iconss: Icons.verified_user,
                              //     detail: 'Role: ${userData['role']}'),
                              const SizedBox(height: 5),
                              // const SizedBox(height: 30),
                            ]);
                          },
                        ),
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('student')
                              .doc(currentUser!.uid)
                              .snapshots(),
                          builder: (context, studentSnapshot) {
                            if (studentSnapshot.hasError) {
                              return Center(
                                child: Text('Error: ${studentSnapshot.error}'),
                              );
                            }

                            if (!studentSnapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            var studentData = studentSnapshot.data!.data();

                            return Column(
                              children: [
                                ProfileCard(
                                    iconss: Icons.email,
                                    detail:
                                        'Roll no: ${studentData?['rollno'] ?? 'N/A'}'),
                                const SizedBox(height: 5),
                                ProfileCard(
                                    iconss: Icons.mobile_friendly,
                                    detail:
                                        'Semester: ${studentData?['semester'] ?? 'N/A'}'),
                                const SizedBox(height: 5),
                                ProfileCard(
                                    iconss: Icons.calendar_month,
                                    detail:
                                        'Department: ${studentData?['department'] ?? 'N/A'}'),
                              ],
                            );
                          },
                        ),
                      ]);
                } else {
                  return ListView(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      children: [
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(currentUser!.uid)
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
                            // Here, you can access the user's data from the snapshot
                            var userData = snapshot.data!.data();
                            return Column(children: [
                              Container(
                                // margin: const EdgeInsets.only(top: 30),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [AppColors.black, AppColors.blue],
                                  ),
                                  // borderRadius: BorderRadius.only(
                                  //     bottomLeft: Radius.circular(60),
                                  //     bottomRight: Radius.circular(60))
                                ),
                                child: SizedBox(
                                  height: 55,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const SizedBox(height: 30),
                                      Text(userData!['name'],
                                          style: const TextStyle(
                                              fontSize: 22,
                                              color: AppColors.white)),
                                      const SizedBox(height: 10),
                                      Text(
                                          userData['role'] == 'Admin'
                                              ? ' | Admin '
                                              : ' | Student ',
                                          style: const TextStyle(
                                              fontSize: 22,
                                              color: AppColors.white)),
                                      const SizedBox(height: 10),
                                      StreamBuilder<
                                          DocumentSnapshot<
                                              Map<String, dynamic>>>(
                                        stream: FirebaseFirestore.instance
                                            .collection('student')
                                            .doc(currentUser!.uid)
                                            .snapshots(),
                                        builder: (context, studentSnapshot) {
                                          if (studentSnapshot.hasError) {
                                            return Center(
                                              child: Text(
                                                  'Error: ${studentSnapshot.error}'),
                                            );
                                          }

                                          if (!studentSnapshot.hasData) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }

                                          var studentData =
                                              studentSnapshot.data!.data();
                                          String studentImageUrl =
                                              studentData?['image'] ??
                                                  ''; // Get the image URL

                                          return CircleAvatar(
                                            radius: 20,
                                            backgroundImage: studentImageUrl
                                                    .isNotEmpty
                                                ? NetworkImage(studentImageUrl)
                                                : null,
                                            backgroundColor: AppColors.bgcolor,
                                          );
                                        },
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                            height: 40,
                                            width: 40,
                                            // decoration: BoxDecoration(
                                            //     color: const Color.fromARGB(
                                            //         255, 116, 154, 199),
                                            //     borderRadius:
                                            //         BorderRadius.circular(10)),
                                            child: IconButton(
                                              icon: const Icon(Icons.logout,
                                                  color: AppColors.white),
                                              onPressed: () {
                                                FirebaseAuth.instance.signOut();
                                                setState(() {
                                                  islogout = true;
                                                });
                                                Utils.toastMessage(
                                                    'Logged Out!!!');
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: ((context) =>
                                                            const SignInScreen())));
                                              },
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),
                              // You can display the user's data here
                              ProfileCard(
                                  iconss: Icons.email,
                                  detail: 'Email: ${userData['email']}'),
                              // const SizedBox(height: 5),
                              // ProfileCard(
                              //     iconss: Icons.person, detail: 'Name: ${userData['name']}'),
                              const SizedBox(height: 5),
                              ProfileCard(
                                  iconss: Icons.phone,
                                  detail: 'Phone: ${userData['phone']}'),
                              // ProfileCard(
                              //     iconss: Icons.verified_user,
                              //     detail: 'Role: ${userData['role']}'),
                              const SizedBox(height: 5),
                              // const SizedBox(height: 30),
                            ]);
                          },
                        ),
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('student')
                              .doc(currentUser!.uid)
                              .snapshots(),
                          builder: (context, studentSnapshot) {
                            if (studentSnapshot.hasError) {
                              return Center(
                                child: Text('Error: ${studentSnapshot.error}'),
                              );
                            }

                            if (!studentSnapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            var studentData = studentSnapshot.data!.data();

                            return Column(
                              children: [
                                ProfileCard(
                                    iconss: Icons.email,
                                    detail:
                                        'Roll no: ${studentData?['rollno'] ?? 'N/A'}'),
                                const SizedBox(height: 5),
                                ProfileCard(
                                    iconss: Icons.mobile_friendly,
                                    detail:
                                        'Semester: ${studentData?['semester'] ?? 'N/A'}'),
                                const SizedBox(height: 5),
                                ProfileCard(
                                    iconss: Icons.calendar_month,
                                    detail:
                                        'Department: ${studentData?['department'] ?? 'N/A'}'),
                              ],
                            );
                          },
                        ),
                      ]);
                }
              }),
            )));
  }
}
