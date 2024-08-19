import 'dart:convert';

import 'package:face_recognition_attendance_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MarkAttendanceScreen extends StatefulWidget {
  @override
  _MarkAttendanceScreenState createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  CameraController? cameraController;
  late List<CameraDescription> cameras;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);

    await cameraController!.initialize();

    if (!mounted) return;

    setState(() {
      isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  Future<void> captureAndProcessImage() async {
    if (!cameraController!.value.isInitialized) {
      // Handle camera not initialized error.
      return;
    }

    try {
      final XFile image = await cameraController!.takePicture();
      final imageBytes = await image.readAsBytes();
      final imageUrl = await uploadImageToCloud(imageBytes);

      // Fetch all student documents from the 'student' collection
      final QuerySnapshot studentQuerySnapshot =
          await FirebaseFirestore.instance.collection('student').get();

      // Loop through all student documents
      for (final studentDoc in studentQuerySnapshot.docs) {
        final studentData = studentDoc.data() as Map<String, dynamic>;
        final studentImageUrls = studentData['image'] as List<String>;

        Utils.toastMessage('Type of imageUrl: ${imageUrl.runtimeType}');

        final isMatch = await compareImages([imageUrl], studentImageUrls);

        final userId = studentDoc.id;
        final attendanceStatus = isMatch ? 'Present' : 'Absent';
        final currentTime = DateTime.now().toIso8601String();

        await FirebaseFirestore.instance
            .collection('attendance')
            .doc(userId)
            .set({
          'status': attendanceStatus,
          'name': studentData['name'],
          'dateTime': currentTime,
          'rollNumber': studentData['rollNumber'],
          'department': studentData['department'],
          'imagePath': imageUrl,
        });

        if (isMatch) {
          print('Match Found - Marked as Present for ${studentData['name']}');
          Utils.toastMessage(
              'Match Found - Marked as Present for ${studentData['name']}');
        } else {
          print('No Match Found - Marked as Absent for ${studentData['name']}');
          Utils.toastMessage(
              'No Match Found - Marked as Absent for ${studentData['name']}');
        }
      }
    } catch (e) {
      print('Error: $e');
      Utils.toastMessage('Error: $e');
    }
  }

  Future<String> uploadImageToCloud(List<int> imageBytes) async {
    try {
      final docRef =
          await FirebaseFirestore.instance.collection('capturedImages').add({
        'imageBytes': imageBytes,
        'timestamp': FieldValue.serverTimestamp(),
      });

      return docRef.id;
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  Future<bool> compareImages(
    List<String> capturedImageUrls, // Accept a list of captured image URLs
    List<String> studentImageUrls,
  ) async {
    print('Captured Image URLs: $capturedImageUrls');
    print('Student Image URLs: $studentImageUrls');
    const apiKey =
        '26f7b39e42msh0580980a19387bfp1f2a77jsn7c6fc0e6d705'; // Replace with your API key
    const apiUrl =
        'https://ultimate-cloud-vision-image.p.rapidapi.com/google/cloudvision/faces'; // Replace with your API endpoint

    final headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': 'ultimate-cloud-vision-image.p.rapidapi.com',
    };
    final requestBody = {
      'image': capturedImageUrls[0], // Use the first URL of the captured images
      'target_images': studentImageUrls
          .join(','), // Comma-separated list of student image URLs
    };

    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: headers, body: requestBody);

      if (response.statusCode == 200) {
        final responseData = response.body;
        print('API Response: $responseData');
        final isMatch = parseApiResponse(responseData);
        return isMatch;
      } else {
        print('API request failed with status code ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error during API request: $e');
      return false;
    }
  }

  bool parseApiResponse(String responseData) {
    print('API Response Data: $responseData');
    try {
      final Map<String, dynamic> responseJson = json.decode(responseData);

      if (responseJson.containsKey('faceMatches')) {
        final faceMatches = responseJson['faceMatches'];

        if (faceMatches.isNotEmpty) {
          return true;
        }
      }

      return false;
    } catch (e) {
      print('Error parsing API response: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance'),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: cameraController!.value.aspectRatio,
            child: CameraPreview(cameraController!),
          ),
          ElevatedButton(
            onPressed: captureAndProcessImage,
            child: const Text('Capture and Process Image'),
          ),
        ],
      ),
    );
  }
}
