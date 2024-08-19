import 'package:face_recognition_attendance_app/ui/screens/admin/admin_nav_screen.dart';

import 'package:face_recognition_attendance_app/model/appcolors.dart';
import 'package:face_recognition_attendance_app/ui/screens/auth/forgotpass_screen.dart';

import 'package:face_recognition_attendance_app/ui/screens/auth/signup_screen.dart';
import 'package:face_recognition_attendance_app/ui/widgets/gradient_button_widget.dart';
import 'package:face_recognition_attendance_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreen();
}

class _SignInScreen extends State<SignInScreen> {
  TextEditingController loginEmailController = TextEditingController();
  // TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  bool loading = false;
  bool isAdmin = false;

  bool isPasswordVisible = false;
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: LayoutBuilder(builder: (context, constraints) {
                final isWeb = kIsWeb && constraints.maxWidth > 600;
                if (isWeb) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 70),
                              alignment: Alignment.center,
                              height: 500,
                              width: MediaQuery.sizeOf(context).width / 2,
                              child: Lottie.asset(
                                  "assets/images/animation_lkhg4rnh.json"),
                            ),
                          ],
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 50),
                              const Text('Login',
                                  style: TextStyle(fontSize: 35)),
                              const SizedBox(height: 5),
                              const Text(
                                'Please sign in to continue',
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width / 3,
                                child: Card(
                                  elevation: 5,
                                  child: TextFormField(
                                    controller: loginEmailController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: AppColors.black,
                                      ),
                                      hintText: 'Email',
                                      hintStyle: const TextStyle(
                                          color: AppColors.black),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width / 3,
                                child: Card(
                                  elevation: 5,
                                  child: TextFormField(
                                    controller: loginPasswordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          isPasswordVisible
                                              ? Icons.visibility_off
                                              : Icons
                                                  .visibility, // Toggle icon based on visibility
                                          color: AppColors.black,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isPasswordVisible =
                                                !isPasswordVisible;
                                          });
                                        },
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: AppColors.black,
                                      ),
                                      hintText: 'Password',
                                      hintStyle: const TextStyle(
                                          color: AppColors.black),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ForgotpassScreen()));
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text('Forget Password'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              GradientButton(
                                  width: 150,
                                  title: 'SignIn',
                                  onTap: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    var loginEmail =
                                        loginEmailController.text.trim();
                                    var loginPassword =
                                        loginPasswordController.text.trim();

                                    try {
                                      final UserCredential userCredential =
                                          await FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                        email: loginEmail,
                                        password: loginPassword,
                                      );

                                      if (userCredential.user != null) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AdminNavScreen(), // Navigate to the AdminHomeScreen
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      print("Error during login: $e");
                                      Utils.toastMessage(e.toString());
                                    }
                                    setState(() {
                                      loading = false;
                                    });
                                    // onTap: () async {
                                    //   var loginEmail = loginEmailController.text.trim();
                                    //   var loginPassword = loginPasswordController.text.trim();

                                    //   // Inside the login button's onPressed function
                                    //   try {
                                    //     final UserCredential userCredential =
                                    //         await FirebaseAuth.instance
                                    //             .signInWithEmailAndPassword(
                                    //                 email: loginEmail,
                                    //                 password: loginPassword);

                                    //     if (userCredential.user != null) {
                                    //       DocumentSnapshot userSnapshot =
                                    //           await FirebaseFirestore.instance
                                    //               .collection('users')
                                    //               .doc(userCredential.user!.uid)
                                    //               .get();
                                    //       String userRole = userSnapshot.get('role');

                                    //       if (userRole == 'Admin') {
                                    //         // Navigate to admin dashboard
                                    //         Navigator.pushReplacement(
                                    //           context,
                                    //           MaterialPageRoute(
                                    //               builder: (context) =>
                                    //                   const AdminPanelScreen()),
                                    //         );
                                    //       } else {
                                    //         // Navigate to regular user dashboard
                                    //         Navigator.pushReplacement(
                                    //           context,
                                    //           MaterialPageRoute(
                                    //               builder: (context) => const HomeScreen()),
                                    //         );
                                    //       }
                                    //     }
                                    //   } catch (e) {
                                    //     print("Error during login: $e");
                                    //   }
                                  }),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      const Text("Don't have an account. "),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SignupScreen()));
                                        },
                                        child: const Text("SignUp",
                                            style: TextStyle(
                                                color: AppColors.black)),
                                      )
                                    ],
                                  ))
                            ])
                      ]);
                } else {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          alignment: Alignment.center,
                          height: 300,
                          child: Lottie.asset(
                              "assets/images/animation_lkhg4rnh.json"),
                        ),
                        const Text('Login', style: TextStyle(fontSize: 35)),
                        const SizedBox(height: 5),
                        const Text(
                          'Please sign in to continue',
                        ),
                        const SizedBox(height: 20),
                        Card(
                          elevation: 5,
                          child: TextFormField(
                            controller: loginEmailController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email,
                                color: AppColors.black,
                              ),
                              hintText: 'Email',
                              hintStyle:
                                  const TextStyle(color: AppColors.black),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Card(
                          elevation: 5,
                          child: TextFormField(
                            controller: loginPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons
                                          .visibility, // Toggle icon based on visibility
                                  color: AppColors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: AppColors.black,
                              ),
                              hintText: 'Password',
                              hintStyle:
                                  const TextStyle(color: AppColors.black),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotpassScreen()));
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text('Forget Password'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GradientButton(
                                width: 150,
                                title: 'SignIn',
                                onTap: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  var loginEmail =
                                      loginEmailController.text.trim();
                                  var loginPassword =
                                      loginPasswordController.text.trim();

                                  try {
                                    final UserCredential userCredential =
                                        await FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                      email: loginEmail,
                                      password: loginPassword,
                                    );

                                    if (userCredential.user != null) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AdminNavScreen(), // Navigate to the AdminHomeScreen
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    print("Error during login: $e");
                                    Utils.toastMessage(e.toString());
                                  }
                                  setState(() {
                                    loading = false;
                                  });
                                  // onTap: () async {
                                  //   var loginEmail = loginEmailController.text.trim();
                                  //   var loginPassword = loginPasswordController.text.trim();

                                  //   // Inside the login button's onPressed function
                                  //   try {
                                  //     final UserCredential userCredential =
                                  //         await FirebaseAuth.instance
                                  //             .signInWithEmailAndPassword(
                                  //                 email: loginEmail,
                                  //                 password: loginPassword);

                                  //     if (userCredential.user != null) {
                                  //       DocumentSnapshot userSnapshot =
                                  //           await FirebaseFirestore.instance
                                  //               .collection('users')
                                  //               .doc(userCredential.user!.uid)
                                  //               .get();
                                  //       String userRole = userSnapshot.get('role');

                                  //       if (userRole == 'Admin') {
                                  //         // Navigate to admin dashboard
                                  //         Navigator.pushReplacement(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) =>
                                  //                   const AdminPanelScreen()),
                                  //         );
                                  //       } else {
                                  //         // Navigate to regular user dashboard
                                  //         Navigator.pushReplacement(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) => const HomeScreen()),
                                  //         );
                                  //       }
                                  //     }
                                  //   } catch (e) {
                                  //     print("Error during login: $e");
                                  //   }
                                }),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                const Text("Don't have an account. "),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignupScreen()));
                                  },
                                  child: const Text("SignUp",
                                      style: TextStyle(color: AppColors.black)),
                                )
                              ],
                            ))
                      ]);
                }
              }),
            ),
          ),
        ));
  }
}
