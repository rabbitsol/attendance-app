// import 'dart:async';
// import 'dart:math' as math;
// import 'dart:typed_data';
// import 'dart:ui' as ui;

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:tflite/tflite.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   final cameras = await availableCameras();
//   final camera = cameras.first;

//   runApp(MyApp(camera: camera));
// }

// class MyApp extends StatelessWidget {
//   final CameraDescription camera;

//   const MyApp({Key? key, required this.camera}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Face Recognition Demo',
//       home: FaceRecognitionScreen(camera: camera),
//     );
//   }
// }

// class FaceRecognitionScreen extends StatefulWidget {
//   final CameraDescription camera;

//   const FaceRecognitionScreen({Key? key, required this.camera}) : super(key: key);

//   @override
//   _FaceRecognitionScreenState createState() => _FaceRecognitionScreenState();
// }

// class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
//   CameraController? _cameraController;
//   late StreamSubscription<ui.Image> _subscription;
//   List<dynamic>? _recognitions;

//   @override
//   void initState() {
//     super.initState();

//     Tflite.loadModel(
//       model: 'assets/models/mobilefacenet.tflite',
//       labels: 'assets/models/mobilefacenet_labels.txt',
//     );

//     _cameraController = CameraController(widget.camera, ResolutionPreset.medium);
//     _cameraController!.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }

//       setState(() {});

//       _subscription = _cameraController!.startImageStream((image) async {
//         final recognitions = await Tflite.runModelOnBinary(
//           binary: _imageToByteListFloat32(image),
//           numResults: 1,
//         );

//         setState(() {
//           _recognitions = recognitions;
//         });
//       }) as StreamSubscription<ui.Image>;
//     });
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     _cameraController?.dispose();
//     Tflite.close();

//     super.dispose();
//   }


// ui.Image convertCameraImage(CameraImage image) {
//   final width = image.width;
//   final height = image.height;

//   final img = ui.Image(width, height);

//   final buffer = image.planes[0].bytes;
//   final bytesPerRow = image.planes[0].bytesPerRow;
//   final stride = bytesPerRow ~/ width;

//   img.data.buffer.asUint8List().setRange(0, buffer.lengthInBytes, buffer);

//   return img;
// }

//   Uint8List _imageToByteListFloat32(ui.Image image) {
//     final width = image.width;
//     final height = image.height;

//     final bytes = Float32List(1 * width * height * 3);

//     for (var y = 0; y < height; y++) {
//       for (var x = 0; x < width; x++) {
//         final pixel = image.getPixel(x, y);

//         bytes[(0 * height * width) + (y * width) + x] = ((pixel >> 16) & 0xFF) / 255.0;
//         bytes[(1 * height * width) + (y * width) + x] = ((pixel >> 8) & 0xFF) / 255.0;
//         bytes[(2 * height * width) + (y * width) + x] = ((pixel >> 0) & 0xFF) / 255.0;
//       }
//     }

//     return bytes.buffer.asUint8List();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_cameraController!.value.isInitialized) {
//       return Container();
//     }

//     return AspectRatio(
//       aspectRatio: _cameraController!.value.aspectRatio,
//       child: Stack(
//         children: [
//           CameraPreview(_cameraController!),
//           if (_recognitions != null)
//             Positioned(
//               top: math.max(0, MediaQuery.of(context).padding.top),
//               left: math.max(0, MediaQuery.of(context).padding.left),
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 color: Colors.black.withOpacity(0.5),
//                 child: Text(
//                   'Recognitions: ${_recognitions![0]['label']}',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: math.min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) / 20,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

