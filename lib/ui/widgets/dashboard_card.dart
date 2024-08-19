import 'package:face_recognition_attendance_app/model/appcolors.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String iconss;
  final String title;
  final String subtitle;
  final VoidCallback ontap;
  const DashboardCard(
      {super.key,
      required this.iconss,
      required this.title,
      required this.subtitle,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Card(
          elevation: 5,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Container(
              height: 170,
              // margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromARGB(255, 216, 227, 241),
                        // .withOpacity(0.1),
                        Color(0xFFFFFFFF)
                        // .withOpacity(0.05),
                      ],
                      stops: [
                        0.1,
                        1,
                      ]),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(iconss),
                    Text(
                      title,
                      style:
                          const TextStyle(color: AppColors.black, fontSize: 18),
                    ),
                    Text(subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 14,
                        ))
                  ]))),
    );
  }
}
