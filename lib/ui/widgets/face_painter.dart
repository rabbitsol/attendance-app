// import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';

// class FacePainter extends CustomPainter {
//   final List<Face> faces;

//   FacePainter(this.faces);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0;
//     for (final face in faces) {
//       final rect = face.boundingBox;
//       canvas.drawRect(rect, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(FacePainter oldDelegate) {
//     return faces != oldDelegate.faces;
//   }
// }
