import 'package:face_recognition_attendance_app/model/appcolors.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final IconData iconss;
  final String detail;
  const ProfileCard({super.key, required this.iconss, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Card(
          elevation: 5,
          child: ListTile(
            leading: Icon(
              iconss,
              size: 25,
              color: AppColors.black,
            ),
            title: Text(
              detail,
              style: const TextStyle(color: AppColors.black, fontSize: 16),
            ),
          )),
    );
  }
}
