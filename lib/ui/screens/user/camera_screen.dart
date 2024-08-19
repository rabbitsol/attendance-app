import 'dart:io';

import 'package:camera/camera.dart';
import 'package:face_recognition_attendance_app/model/appcolors.dart';
import 'package:face_recognition_attendance_app/ui/screens/user/enroll_student_screen.dart';
import 'package:face_recognition_attendance_app/ui/widgets/gradient_button_widget.dart';
import 'package:face_recognition_attendance_app/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      Utils.toastMessage('No available cameras found.');
      return;
    }
    final firstCamera = cameras[0]; // back 0th index & front 1st index

    controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller.initialize();
    setState(() {
      isCameraInitialized = true;
    });
  }

  Future<void> takePictureAndNavigateToEnrollScreen() async {
    if (!controller.value.isInitialized) {
      Utils.toastMessage('Error: Camera is not initialized.');
      return;
    }

    final XFile pictureFile = await controller.takePicture();

    if (pictureFile != null) {
      // Now you can store the image in Firebase Storage
      String imageUrl = await uploadImage(File(pictureFile.path));

      // Navigate to EnrollStudentScreen and pass the captured image URL
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EnrollStudentScreen(capturedImageUrl: imageUrl),
        ),
      );
    }
  }

  // void takePicture() async {
  //   if (!controller.value.isInitialized) {
  //     Utils.toastMessage('Error: Camera is not initialized.');
  //     return;
  //   }

  //   final XFile pictureFile = await controller!.takePicture();

  //   if (pictureFile != null) {
  //     // Now you can store the image in Firebase Storage or wherever you want
  //     String imageUrl = await uploadImage(File(pictureFile.path));
  //     Utils.toastMessage('Picture taken and uploaded: $imageUrl');
  //   }
  // }

  Future<String> uploadImage(File image) async {
    String fileName = Path.basename(image.path);
    var reference = FirebaseStorage.instance.ref().child('student/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Color.fromARGB(255, 205, 219, 238),
                  // .withOpacity(0.1),
                  Color(0xFFFFFFFF)
                  // .withOpacity(0.05),
                ],
                    stops: [
                  0.1,
                  1,
                ])),
            child: LayoutBuilder(builder: (context, constraints) {
              final isWeb = kIsWeb && constraints.maxWidth > 600;
              if (!isWeb) {
                return Column(
                  children: [
                    const SizedBox(height: 50),
                    Center(
                      child: SizedBox(
                          height: MediaQuery.sizeOf(context).height / 1.5,
                          width: MediaQuery.sizeOf(context).width / 1.2,
                          child: isCameraInitialized
                              ? AspectRatio(
                                  aspectRatio: controller.value.aspectRatio,
                                  child: CameraPreview(controller),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(
                                      color: AppColors.black))),
                    ),
                    const SizedBox(height: 30),
                    GradientButton(
                        title: 'Take Picture',
                        onTap: takePictureAndNavigateToEnrollScreen,
                        width: 150)
                  ],
                );
              } else {
                return Column(
                  children: [
                    Center(
                      child: SizedBox(
                          height: MediaQuery.sizeOf(context).height / 1.2,
                          width: MediaQuery.sizeOf(context).width / 2,
                          child: isCameraInitialized
                              ? AspectRatio(
                                  aspectRatio: controller.value.aspectRatio,
                                  child: CameraPreview(controller),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(
                                      color: AppColors.black))),
                    ),
                    const SizedBox(height: 30),
                    GradientButton(
                        title: 'Take Picture',
                        onTap: takePictureAndNavigateToEnrollScreen,
                        width: 150)
                  ],
                );
              }
            })));
  }
}
