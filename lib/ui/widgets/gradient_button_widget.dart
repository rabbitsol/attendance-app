import 'package:face_recognition_attendance_app/model/appcolors.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  final double width;
  // final Color btntxtcolor;
  const GradientButton(
      {Key? key,
      required this.title,
      required this.onTap,
      required this.width,
      // required this.btntxtcolor,
      this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: AppColors.linearGradientforbtn),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.white,
                )
              : Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
