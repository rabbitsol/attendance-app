import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_recognition_attendance_app/model/appcolors.dart';
import 'package:face_recognition_attendance_app/ui/screens/auth/signin_screen.dart';
import 'package:face_recognition_attendance_app/ui/widgets/gradient_button_widget.dart';
import 'package:face_recognition_attendance_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  Future<void> signUpUser(
    BuildContext context,
    String userName,
    String userPhone,
    String userEmail,
    String userPassword,
    String selectedRole,
  ) async {
    try {
      UserCredential authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userEmail, password: userPassword);

      // Store user's role in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({
        'name': userName,
        'phone': userPhone,
        'email': userEmail,
        'role': selectedRole,
      });

      Utils.toastMessage('User Successfully created');
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SignInScreen()));
    } catch (e) {
      print("Error during signup: $e");
      Utils.toastMessage(e.toString());
    }
  }

  User? currentUser = FirebaseAuth.instance.currentUser;
  String selectedRole = 'User'; // Default role
  @override
  Widget build(BuildContext context) {
    return Container(
        // height: MediaQuery.sizeOf(context).height,
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
                if (!isWeb) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        // color: Colors.amber,
                        alignment: Alignment.center,
                        height: 200,
                        child: Lottie.asset(
                            "assets/images/animation_lkhg4rnh.json",
                            fit: BoxFit.cover),
                      ),
                      const Text('Sign Up', style: TextStyle(fontSize: 35)),
                      const SizedBox(height: 5),
                      const Text(
                        'Please sign up to make an account',
                      ),
                      const SizedBox(height: 15),
                      Card(
                        elevation: 5,
                        child: TextFormField(
                          controller: userNameController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person,
                                color: AppColors.black),
                            hintText: 'username',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Card(
                        elevation: 5,
                        child: TextFormField(
                          controller: userPhoneController,
                          decoration: InputDecoration(
                            prefixIcon:
                                const Icon(Icons.phone, color: AppColors.black),
                            hintText: 'phone',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Card(
                        elevation: 5,
                        child: TextFormField(
                          controller: userEmailController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.email,
                              color: AppColors.black,
                            ),
                            hintText: 'Email',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Card(
                        elevation: 5,
                        child: TextFormField(
                          controller: userPasswordController,
                          decoration: InputDecoration(
                            suffixIcon: const Icon(Icons.visibility),
                            prefixIcon:
                                const Icon(Icons.lock, color: AppColors.black),
                            hintText: 'password',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Card(
                        elevation: 5,
                        child: TextFormField(
                          controller: userPasswordController,
                          decoration: InputDecoration(
                            suffixIcon: const Icon(Icons.visibility),
                            prefixIcon:
                                const Icon(Icons.lock, color: AppColors.black),
                            hintText: 'Confirm Password',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GradientButton(
                            title: 'SignUp',
                            onTap: () async {
                              var userName = userNameController.text.trim();
                              var userPhone = userPhoneController.text.trim();
                              var userEmail = userEmailController.text.trim();
                              var userPassword =
                                  userPasswordController.text.trim();

                              await signUpUser(context, userName, userPhone,
                                  userEmail, userPassword, selectedRole);
                            },
                            width: 150),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          const Text("Already have an account. "),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignInScreen()));
                            },
                            child: const Text("Sign In",
                                style: TextStyle(color: AppColors.black)),
                          )
                        ],
                      )
                    ],
                  );
                } else {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 60),
                              Container(
                                // color: Colors.amber,
                                alignment: Alignment.center,
                                height: 500,
                                child: Lottie.asset(
                                    "assets/images/animation_lkhg4rnh.json",
                                    fit: BoxFit.cover),
                              ),
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 60),
                              const Text('Sign Up',
                                  style: TextStyle(fontSize: 35)),
                              const SizedBox(height: 5),
                              const Text(
                                'Please sign up to make an account',
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                  width: MediaQuery.sizeOf(context).width / 3,
                                  child: Card(
                                    elevation: 5,
                                    child: TextFormField(
                                      controller: userNameController,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.person,
                                            color: AppColors.black),
                                        hintText: 'username',
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                  )),
                              const SizedBox(height: 5),
                              SizedBox(
                                  width: MediaQuery.sizeOf(context).width / 3,
                                  child: Card(
                                    elevation: 5,
                                    child: TextFormField(
                                      controller: userPhoneController,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.phone,
                                            color: AppColors.black),
                                        hintText: 'phone',
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                  )),
                              const SizedBox(height: 5),
                              SizedBox(
                                  width: MediaQuery.sizeOf(context).width / 3,
                                  child: Card(
                                    elevation: 5,
                                    child: TextFormField(
                                      controller: userEmailController,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.email,
                                          color: AppColors.black,
                                        ),
                                        hintText: 'Email',
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                  )),
                              const SizedBox(height: 5),
                              SizedBox(
                                  width: MediaQuery.sizeOf(context).width / 3,
                                  child: Card(
                                    elevation: 5,
                                    child: TextFormField(
                                      controller: userPasswordController,
                                      decoration: InputDecoration(
                                        suffixIcon:
                                            const Icon(Icons.visibility),
                                        prefixIcon: const Icon(Icons.lock,
                                            color: AppColors.black),
                                        hintText: 'password',
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                  )),
                              const SizedBox(height: 5),
                              SizedBox(
                                  width: MediaQuery.sizeOf(context).width / 3,
                                  child: Card(
                                    elevation: 5,
                                    child: TextFormField(
                                      controller: userPasswordController,
                                      decoration: InputDecoration(
                                        suffixIcon:
                                            const Icon(Icons.visibility),
                                        prefixIcon: const Icon(Icons.lock,
                                            color: AppColors.black),
                                        hintText: 'Confirm Password',
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                  )),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GradientButton(
                                    title: 'SignUp',
                                    onTap: () async {
                                      var userName =
                                          userNameController.text.trim();
                                      var userPhone =
                                          userPhoneController.text.trim();
                                      var userEmail =
                                          userEmailController.text.trim();
                                      var userPassword =
                                          userPasswordController.text.trim();

                                      await signUpUser(
                                          context,
                                          userName,
                                          userPhone,
                                          userEmail,
                                          userPassword,
                                          selectedRole);
                                    },
                                    width: 150),
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                children: [
                                  const Text("Already have an account. "),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignInScreen()));
                                    },
                                    child: const Text("Sign In",
                                        style:
                                            TextStyle(color: AppColors.black)),
                                  )
                                ],
                              )
                            ])
                      ]);
                }
              }),
            ))));
  }
}
