import 'package:face_recognition_attendance_app/model/appcolors.dart';
import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback ontap;
  final Widget? icons;
  const CustomBottomNav(
      {super.key,
      required this.icon,
      required this.selected,
      required this.ontap,
      required this.icons});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icons ??
              Icon(
                (icon),
                color: selected
                    ? AppColors.black
                    : const Color.fromARGB(255, 147, 181, 223),
              ),
          Text('Home',
              style: TextStyle(
                  color: selected
                      ? AppColors.black
                      : const Color.fromARGB(255, 147, 181, 223)))
          // if (selected)
          // ImageIcon(
          //   // AssetImage(AppIcons.navrectangleforselected),
          //   color: const Color(0xff2C91EF),
          // ),
        ],
      ),
    );
  }
}
