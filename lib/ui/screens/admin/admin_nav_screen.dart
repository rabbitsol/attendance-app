import 'package:face_recognition_attendance_app/model/appcolors.dart';
import 'package:face_recognition_attendance_app/ui/screens/admin/admin_panel_screen.dart';
import 'package:face_recognition_attendance_app/ui/screens/user/profile_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdminNavScreen extends StatefulWidget {
  const AdminNavScreen({super.key});

  @override
  State<AdminNavScreen> createState() => _AdminNavScreenState();
}

class _AdminNavScreenState extends State<AdminNavScreen> {
  int pageIndex = 0;
  bool isDrawerOpen = true; // Track whether the drawer is open or closed
  final page = [
    const AdminPanelScreen(),
    const ProfileScreen(),
  ];
  bool select = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isWeb = kIsWeb && constraints.maxWidth > 600;
      if (isWeb) {
        // For larger screen widths (Web), display a side drawer
        return Scaffold(
          body: Row(
            children: [
              // Drawer Icon (Visible when the drawer is closed)

              // if (!isDrawerOpen)
              //   IconButton(
              //     icon: const Icon(Icons.menu),
              //     onPressed: () {
              //       setState(() {
              //         isDrawerOpen = !isDrawerOpen; // Toggle the drawer state
              //       });
              //     },
              //   ),
              // Custom Drawer
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 250, // Drawer width (permanently open)
                color: AppColors.black, // Drawer background color
                child: ListView(
                  children: [
                    const SizedBox(height: 30),
                    const ListTile(
                        leading: Text(
                      'Face Recognition\n Attendance App',
                      style: TextStyle(color: AppColors.white, fontSize: 22),
                    )
                        // Builder(builder: (context) {
                        //   return IconButton(
                        //     icon: const Icon(Icons.menu, color: AppColors.white),
                        //     onPressed: () {
                        //       setState(() {
                        //         isDrawerOpen =
                        //             !isDrawerOpen; // Toggle the drawer state
                        //       });
                        //     },
                        //   );
                        // })
                        ),
                    // Drawer items
                    const SizedBox(height: 30),
                    ListTile(
                      leading: Icon(Icons.home,
                          color: select ? AppColors.aqua : AppColors.white),
                      title: Text(
                        'Home',
                        style: TextStyle(
                            color: select ? AppColors.aqua : AppColors.white),
                      ),
                      selected: pageIndex == 0,
                      onTap: () {
                        setState(() {
                          pageIndex = 0;
                        });
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.person,
                          color: select ? AppColors.aqua : AppColors.white),
                      title: Text(
                        'Profile',
                        style: TextStyle(
                            color: select ? AppColors.aqua : AppColors.white),
                      ),
                      selected: pageIndex == 1,
                      onTap: () {
                        setState(() {
                          pageIndex = 1;
                        });
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.question_mark_rounded,
                          color: select ? AppColors.aqua : AppColors.white),
                      title: Text(
                        'FAQ',
                        style: TextStyle(
                            color: select ? AppColors.aqua : AppColors.white),
                      ),
                      selected: pageIndex == 1,
                      onTap: () {
                        setState(() {
                          pageIndex = 1;
                        });
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout,
                          color: select ? AppColors.aqua : AppColors.white),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                            color: select ? AppColors.aqua : AppColors.white),
                      ),
                      selected: pageIndex == 1,
                      onTap: () {
                        setState(() {
                          pageIndex = 1;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: Center(child: page[pageIndex]),
              ),
            ],
          ),
        );
      } else {
        // For smaller screen widths (Mobile), display the bottom navigation bar
        return Scaffold(
          body: Center(child: page[pageIndex]),
          // extendBody: true,
          bottomNavigationBar: Container(
            height: MediaQuery.of(context).size.height * 0.13,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 2)],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  iconWidget(Icons.home, pageIndex == 0, () {
                    setState(() {
                      pageIndex = 0;
                    });
                  }, 'HOME'),
                  iconWidget(Icons.person, pageIndex == 1, () {
                    setState(() {
                      pageIndex = 1;
                    });
                  }, 'PROFILE'),
                ],
              ),
            ),
          ),
        );
      }
    });
  }

  iconWidget(
      IconData icon, bool selected, VoidCallback ontap, String screenname,
      {Widget? icons}) {
    return InkWell(
      onTap: ontap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icons ??
              Icon(icon,
                  size: 40,
                  color: selected
                      ? AppColors.black
                      : const Color.fromARGB(255, 131, 163, 202)),
          Text(
            screenname,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: selected
                    ? AppColors.black
                    : const Color.fromARGB(255, 131, 163, 202)),
          )
          // if (selected)
          //   ImageIcon(
          //     AssetImage(AppIcons.),
          //     color: const Color(0xff2C91EF),
          //   ),
        ],
      ),
    );
  }
}
