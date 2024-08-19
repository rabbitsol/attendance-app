import 'package:face_recognition_attendance_app/model/appcolors.dart';
import 'package:face_recognition_attendance_app/ui/screens/auth/signin_screen.dart';
import 'package:face_recognition_attendance_app/ui/widgets/gradient_button_widget.dart';
import 'package:face_recognition_attendance_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ForgotpassScreen extends StatefulWidget {
  const ForgotpassScreen({Key? key}) : super(key: key);

  @override
  State<ForgotpassScreen> createState() => _ForgotpassScreen();
}

class _ForgotpassScreen extends State<ForgotpassScreen> {
  TextEditingController forgetPasswordController = TextEditingController();

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
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      Container(
                        alignment: Alignment.center,
                        height: 250,
                        child: Lottie.asset(
                            "assets/images/animation_lkhg4rnh.json"),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const SizedBox(height: 50),
                      const Text('Re-Enter Email',
                          style: TextStyle(fontSize: 35)),
                      const SizedBox(height: 5),
                      const Text(
                        'Please Re-enter email if you forgot password',
                      ),
                      const SizedBox(height: 20),
                      Card(
                        // color: AppColors.white,
                        elevation: 5,
                        child: TextFormField(
                          controller: forgetPasswordController,
                          decoration: InputDecoration(
                            prefixIcon:
                                const Icon(Icons.email, color: AppColors.black),
                            hintText: 'Email',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GradientButton(
                              title: 'Forget password',
                              onTap: () async {
                                var forgotEmail =
                                    forgetPasswordController.text.trim();

                                try {
                                  FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                          email: forgotEmail)
                                      .then((value) => {
                                            print("Email sent! "),
                                            Utils.toastMessage('Email  Sent!!'),
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SignInScreen()))
                                          });
                                } on FirebaseAuthException catch (e) {
                                  print("Error $e");
                                  Utils.toastMessage(e.toString());
                                }
                              },
                              width: 200),
                        ],
                      )
                    ],
                  ),
                );
              } else {
                return Padding(
                    padding: const EdgeInsets.fromLTRB(30, 70, 30, 70),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(children: [
                            Container(
                              alignment: Alignment.center,
                              height: 500,
                              child: Lottie.asset(
                                  "assets/images/animation_lkhg4rnh.json"),
                            ),
                          ]),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 120),
                              const Text('Re-Enter Email',
                                  style: TextStyle(fontSize: 35)),
                              const SizedBox(height: 5),
                              const Text(
                                'Please Re-enter email if you forgot password',
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              SizedBox(
                                  width: MediaQuery.sizeOf(context).width / 3,
                                  child: Card(
                                    // color: AppColors.white,
                                    elevation: 5,
                                    child: TextFormField(
                                      controller: forgetPasswordController,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.email,
                                            color: AppColors.black),
                                        hintText: 'Email',
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                  )),
                              const SizedBox(
                                height: 30.0,
                              ),
                              GradientButton(
                                  title: 'Reset Password',
                                  onTap: () async {
                                    var forgotEmail =
                                        forgetPasswordController.text.trim();
                                    try {
                                      FirebaseAuth.instance
                                          .sendPasswordResetEmail(
                                              email: forgotEmail)
                                          .then((value) => {
                                                print("Email sent! "),
                                                Utils.toastMessage(
                                                    'Email  Sent!!'),
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const SignInScreen()))
                                              });
                                    } on FirebaseAuthException catch (e) {
                                      print("Error $e");
                                      Utils.toastMessage(e.toString());
                                    }
                                  },
                                  width: 200)
                            ],
                          )
                        ]));
              }
            }))));
  }
}
