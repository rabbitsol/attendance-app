import 'package:face_recognition_attendance_app/model/appIcons.dart';
import 'package:face_recognition_attendance_app/model/appcolors.dart';
import 'package:face_recognition_attendance_app/services/splash_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices = SplashServices();
  @override
  void initState() {
    super.initState();
    splashServices.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: Center(
        child: Image.asset(
          AppIcons.splash,
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
