import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_recognition_attendance_app/ui/screens/admin/class_attendance_report.dart';
import 'package:face_recognition_attendance_app/ui/screens/admin/mark_attendance.dart';
import 'package:face_recognition_attendance_app/model/appIcons.dart';
import 'package:face_recognition_attendance_app/model/appcolors.dart';
import 'package:face_recognition_attendance_app/ui/screens/admin/class_detail_screen.dart';
import 'package:face_recognition_attendance_app/ui/screens/user/enroll_student_screen.dart';
import 'package:face_recognition_attendance_app/ui/screens/user/show_attendance.dart';
import 'package:face_recognition_attendance_app/ui/screens/user/student_attendance_report.dart';
import 'package:face_recognition_attendance_app/ui/widgets/dashboard_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  bool islogout = false;
  String userFirstLetter =
      ''; // Initialize an empty string for the first letter
  String userName = ''; // Initialize an empty string for the user's name
  String userRole = '';
  @override
  void initState() {
    super.initState();
    _getUserData(); // Call this function to retrieve user data
  }

  Future<void> _getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      final name = userDoc['name'] as String;
      final role = userDoc['role'] as String;
      // final userName = userDoc['name'] as String;
      final initials = name.isNotEmpty ? name[0].toUpperCase() : '';
      setState(() {
        userFirstLetter = initials;
        userName = name;
        userRole = role;
      });
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

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
            body: LayoutBuilder(builder: (context, constraints) {
              final isWeb = kIsWeb && constraints.maxWidth > 600;
              if (!isWeb) {
                return Container(
                  height: MediaQuery.sizeOf(context).height,
                  decoration: const BoxDecoration(
                      gradient: AppColors.linearGradientforbg),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ListTile(
                          // tileColor: Colors.amber,
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.white,
                            child: Text(
                              userFirstLetter,
                              // FirebaseAuth.instance.currentUser?.uid..substring(0, 1) ?? '',
                              style: const TextStyle(
                                  color: AppColors
                                      .black, // Set appropriate text color
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Align(
                            alignment: const Alignment(-1.2, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Align the text to the left
                              children: [
                                Text(
                                  'Hi, $userName',
                                  style: const TextStyle(
                                      color: AppColors.white, fontSize: 18),
                                ),
                                const SizedBox(
                                    height:
                                        4), // Add a gap between title and subtitle
                                Text(
                                  getGreeting(),
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.sizeOf(context).height,
                        width: MediaQuery.sizeOf(context).width,
                        decoration: const BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(45),
                                topRight: Radius.circular(45))),
                        child: ListView(
                          physics: const ScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          shrinkWrap: true,
                          children: [
                            const SizedBox(height: 30),
                            Text(
                              DateFormat('yyyy-MM-dd').format(DateTime.now()),
                              style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (userRole == 'Admin')
                              DashboardCard(
                                  ontap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MarkAttendanceScreen()));
                                  },
                                  iconss: AppIcons.markattendance,
                                  title: 'Mark Attendance',
                                  subtitle:
                                      'Detect face to mark student attendance automatically'),
                            if (userRole == 'Admin')
                              DashboardCard(
                                  ontap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ClassDetailScreen()));
                                  },
                                  iconss: AppIcons.classdetails,
                                  title: 'Class Details',
                                  subtitle:
                                      'View whole class student\'s detail'),
                            // if (userRole == 'Admin')
                            //   DashboardCard(
                            //       ontap: () {
                            //         Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //                 builder: (context) =>
                            //                     const AddHolidayScreen()));
                            //       },
                            //       iconss: AppIcons.holiday,
                            //       title: 'Add Holiday',
                            //       subtitle: 'Add public holiday only'),
                            if (userRole == 'Admin')
                              DashboardCard(
                                  ontap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ClassAttendanceReportScreen()));
                                  },
                                  iconss: AppIcons.analytics,
                                  title: 'Class Attendance Report',
                                  subtitle:
                                      'View complete attendance report of class students'),
                            if (userRole == 'User')
                              DashboardCard(
                                  ontap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const EnrollStudentScreen(
                                                    capturedImageUrl: '')));
                                  },
                                  iconss: AppIcons.analytics,
                                  title: 'Enroll in class',
                                  subtitle:
                                      'Enroll the signedin students for attendance'),
                            // if (userRole == 'User')
                            //   DashboardCard(
                            //       ontap: () {
                            //         Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //                 builder: (context) => EnrollmentDetailScreen(
                            //                     uid: FirebaseAuth
                            //                             .instance.currentUser?.uid ??
                            //                         '')));
                            //       },
                            //       iconss: AppIcons.analytics,
                            //       title: 'Enrollment Detail',
                            //       subtitle:
                            //           'Show the detail of enrolled student for attendance'),
                            if (userRole == 'User')
                              DashboardCard(
                                  ontap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ShowAttendanceScreen()));
                                  },
                                  iconss: AppIcons.analytics,
                                  title: 'Show attendance',
                                  subtitle: 'Show the student his attendance'),
                            if (userRole == 'User')
                              DashboardCard(
                                  ontap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const StudentAttendanceReportScreen()));
                                  },
                                  iconss: AppIcons.analytics,
                                  title: 'Class Attendance Report',
                                  subtitle:
                                      'View complete attendance report of class students')
                          ],
                        ),
                      ),
                    ]),
                  ),
                );
              } else {
                return Container(
                  height: MediaQuery.sizeOf(context).height,
                  decoration: const BoxDecoration(
                      gradient: AppColors.linearGradientforbg),
                  child: Column(children: [
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListTile(
                        // tileColor: Colors.amber,
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.white,
                          child: Text(
                            userFirstLetter,
                            // FirebaseAuth.instance.currentUser?.uid..substring(0, 1) ?? '',
                            style: const TextStyle(
                                color: AppColors
                                    .black, // Set appropriate text color
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align the text to the left
                          children: [
                            Text(
                              'Hi, $userName',
                              style: const TextStyle(
                                  color: AppColors.white, fontSize: 18),
                            ),
                            const SizedBox(
                                height:
                                    4), // Add a gap between title and subtitle
                            Text(
                              getGreeting(),
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.sizeOf(context).height / 1.215,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        // borderRadius: BorderRadius.only(
                        //     topLeft: Radius.circular(45),
                        //     topRight: Radius.circular(45)),
                      ),
                      child: ListView(
                        physics: const ScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        shrinkWrap: true,
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (userRole == 'Admin')
                            DashboardCard(
                                ontap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MarkAttendanceScreen()));
                                },
                                iconss: AppIcons.markattendance,
                                title: 'Mark Attendance',
                                subtitle:
                                    'Detect face to mark student attendance automatically'),
                          if (userRole == 'Admin')
                            DashboardCard(
                                ontap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ClassDetailScreen()));
                                },
                                iconss: AppIcons.classdetails,
                                title: 'Class Details',
                                subtitle: 'View whole class student\'s detail'),
                          // if (userRole == 'Admin')
                          //   DashboardCard(
                          //       ontap: () {
                          //         Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) =>
                          //                     const AddHolidayScreen()));
                          //       },
                          //       iconss: AppIcons.holiday,
                          //       title: 'Add Holiday',
                          //       subtitle: 'Add public holiday only'),
                          if (userRole == 'Admin')
                            DashboardCard(
                                ontap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ClassAttendanceReportScreen()));
                                },
                                iconss: AppIcons.analytics,
                                title: 'Class Attendance Report',
                                subtitle:
                                    'View complete attendance report of class students'),
                          if (userRole == 'User')
                            DashboardCard(
                                ontap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const EnrollStudentScreen(
                                                  capturedImageUrl: '')));
                                },
                                iconss: AppIcons.analytics,
                                title: 'Enroll in class',
                                subtitle:
                                    'Enroll the signedin students for attendance'),
                          // if (userRole == 'User')
                          //   DashboardCard(
                          //       ontap: () {
                          //         Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) => EnrollmentDetailScreen(
                          //                     uid: FirebaseAuth
                          //                             .instance.currentUser?.uid ??
                          //                         '')));
                          //       },
                          //       iconss: AppIcons.analytics,
                          //       title: 'Enrollment Detail',
                          //       subtitle:
                          //           'Show the detail of enrolled student for attendance'),
                          if (userRole == 'User')
                            DashboardCard(
                                ontap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ShowAttendanceScreen()));
                                },
                                iconss: AppIcons.analytics,
                                title: 'Show attendance',
                                subtitle: 'Show the student his attendance'),
                          if (userRole == 'User')
                            DashboardCard(
                                ontap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const StudentAttendanceReportScreen()));
                                },
                                iconss: AppIcons.analytics,
                                title: 'Class Attendance Report',
                                subtitle:
                                    'View complete attendance report of class students')
                        ],
                      ),
                    ),
                  ]),
                );
              }
            })));
  }
}
