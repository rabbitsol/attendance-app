import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_recognition_attendance_app/model/appcolors.dart';
import 'package:face_recognition_attendance_app/ui/screens/admin/admin_nav_screen.dart';
import 'package:face_recognition_attendance_app/ui/screens/user/camera_screen.dart';
import 'package:face_recognition_attendance_app/ui/widgets/gradient_button_widget.dart';
import 'package:face_recognition_attendance_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class EnrollStudentScreen extends StatefulWidget {
  const EnrollStudentScreen({Key? key, required String capturedImageUrl})
      : super(key: key);

  @override
  State<EnrollStudentScreen> createState() => _EnrollStudentScreenState();
}

class _EnrollStudentScreenState extends State<EnrollStudentScreen> {
  var isProfileUploading = false.obs;
  CameraController? controller;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollnoController = TextEditingController();
  final TextEditingController semesterContoller = TextEditingController();
  final TextEditingController departmentController = TextEditingController();

  // User? userId = FirebaseAuth.instance.currentUser;
  late DocumentReference studentDocRef;
  @override
  void initState() {
    super.initState();
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    studentDocRef =
        FirebaseFirestore.instance.collection('student').doc(currentUserUid);
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras[0]; // back 0th index & front 1st index

    controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller!.initialize();
    setState(() {});
  }

  void takePicture() async {
    if (!controller!.value.isInitialized) {
      Utils.toastMessage('Error: Camera is not initialized.');
      return;
    }

    final XFile pictureFile = await controller!.takePicture();

    if (pictureFile != null) {
      // Now you can store the image in Firebase Storage or wherever you want
      String imageUrl = await uploadImage(File(pictureFile.path));
      Utils.toastMessage('Picture taken and uploaded: $imageUrl');
    }
  }

  Future<String> uploadImage(File image) async {
    String fileName = Path.basename(image.path);
    var reference = FirebaseStorage.instance.ref().child('student/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  final ImagePicker _picker = ImagePicker();

  File? selectedImage;
  getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  storeUserInfo(File selectedImage, String name, String rollno, String semester,
      String department) async {
    String url = await uploadImage(selectedImage);

    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    // Use the currentUserUid as the document ID when adding to the collection
    DocumentReference studentDocRef =
        FirebaseFirestore.instance.collection('student').doc(currentUserUid);

    studentDocRef.set({
      "createdAt": DateTime.now(),
      "userId": currentUserUid,
      'image': url,
      'name': name,
      'rollno': rollno,
      'semester': semester,
      'department': department,
    }).then((_) {
      Utils.toastMessage('Student data created');
    }).catchError((error) {
      Utils.toastMessage('Error creating student data: $error');
    });
  }

  void enrollStudent() async {
    if (selectedImage == null) {
      Utils.toastMessage("Take a snap!!");
      return;
    }

    if (nameController.text.isEmpty ||
        rollnoController.text.isEmpty ||
        semesterContoller.text.isEmpty ||
        departmentController.text.isEmpty) {
      Utils.toastMessage("Fill in all fields!!");
      return;
    }

    setState(() {
      isloading = true;
    });
    String imageUrl = await uploadImage(
        selectedImage!); // Replace with actual image upload logic
    storeUserInfo(
      selectedImage!,
      nameController.text,
      rollnoController.text,
      semesterContoller.text,
      departmentController.text,
    ).then((_) {
      Utils.toastMessage('Student is enrolled for attendance');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminNavScreen(),
        ),
      );
    }).catchError((error) {
      Utils.toastMessage('Error enrolling student: $error');
    }).whenComplete(() {
      setState(() {
        isloading = false;
      });
    });
  }

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                return Center(
                  child: Container(
                      margin: const EdgeInsets.only(top: 60),
                      decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(1), // Shadow color
                              spreadRadius: 5,
                              blurRadius: 15,
                              offset: const Offset(0, 3), // Shadow position
                            ),
                          ]),
                      alignment: Alignment.center,
                      width: MediaQuery.sizeOf(context).width / 1.07,
                      height: MediaQuery.sizeOf(context).height / 1.12,
                      child: Column(children: [
                        const SizedBox(
                          height: 70,
                        ),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             const CameraScreen()));
                                  getImage(ImageSource.camera);
                                },
                                child: selectedImage == null
                                    ? Container(
                                        width: 150,
                                        height: 150,
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xffD6D6D6),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.camera_alt_outlined,
                                            size: 40,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 150,
                                        height: 150,
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.fitWidth,
                                              image: FileImage(selectedImage!)),
                                          shape: BoxShape.circle,
                                          color: const Color(0xffD6D6D6),
                                        ),
                                      ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Card(
                            elevation: 5,
                            child: TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.account_circle),
                                hintText: 'Name',
                                enabledBorder: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Card(
                              elevation: 5,
                              child: TextFormField(
                                controller: rollnoController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.account_box_sharp),
                                  hintText: 'Roll No',
                                  enabledBorder: OutlineInputBorder(),
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Card(
                              elevation: 5,
                              child: TextFormField(
                                controller: semesterContoller,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email_outlined),
                                  hintText: 'Semester',
                                  enabledBorder: OutlineInputBorder(),
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Card(
                                elevation: 5,
                                child: TextFormField(
                                  controller: departmentController,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.email_outlined),
                                    hintText: 'Department',
                                    enabledBorder: OutlineInputBorder(),
                                  ),
                                ))),
                        const SizedBox(
                          height: 40.0,
                        ),
                        GradientButton(
                            title: 'Enroll',
                            onTap:
                                enrollStudent, // Use the method defined above
                            width: 150),
                      ])),
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(1), // Shadow color
                              spreadRadius: 5,
                              blurRadius: 15,
                              offset: const Offset(0, 3), // Shadow position
                            ),
                          ]),
                      alignment: Alignment.center,
                      width: MediaQuery.sizeOf(context).width / 2,
                      child: Column(children: [
                        const SizedBox(
                          height: 70,
                        ),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: InkWell(
                                onTap: () {
                                  // initializeCamera();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CameraScreen()));
                                  // getImage(ImageSource.camera);
                                },
                                child: selectedImage == null
                                    ? Container(
                                        width: 150,
                                        height: 150,
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xffD6D6D6),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.camera_alt_outlined,
                                            size: 40,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 150,
                                        height: 150,
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.fitWidth,
                                              image: FileImage(selectedImage!)),
                                          shape: BoxShape.circle,
                                          color: const Color(0xffD6D6D6),
                                        ),
                                      ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.sizeOf(context).width / 2.5,
                            child: Card(
                              elevation: 5,
                              child: TextFormField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.account_circle),
                                  hintText: 'Name',
                                  enabledBorder: OutlineInputBorder(),
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                            width: MediaQuery.sizeOf(context).width / 2.5,
                            child: Card(
                              elevation: 5,
                              child: TextFormField(
                                controller: rollnoController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.account_box_sharp),
                                  hintText: 'Roll No',
                                  enabledBorder: OutlineInputBorder(),
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                            width: MediaQuery.sizeOf(context).width / 2.5,
                            child: Card(
                              elevation: 5,
                              child: TextFormField(
                                controller: semesterContoller,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email_outlined),
                                  hintText: 'Semester',
                                  enabledBorder: OutlineInputBorder(),
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 2.5,
                          child: Card(
                              elevation: 5,
                              child: TextFormField(
                                controller: departmentController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email_outlined),
                                  hintText: 'Department',
                                  enabledBorder: OutlineInputBorder(),
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        GradientButton(
                            title: 'Enroll',
                            onTap:
                                enrollStudent, // Use the method defined above
                            width: 150),
                        const SizedBox(
                          height: 15.0,
                        ),
                      ]),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Get Enrolled \n \t\tto mark your\n \t\t\t\tAttendance',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 50,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                );
              }
            }),
          )),
    );
  }
}
