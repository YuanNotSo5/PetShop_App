// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart' as pathProvider;
// import 'package:syncfusion_flutter_sliders/sliders.dart';

// class CameraScreen extends StatefulWidget {
//   const CameraScreen({Key? key}) : super(key: key);

//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   late List<CameraDescription> cameras;
//   CameraController? cameraController;
//   bool isCameraReady = false;

//   // ? Switch camera
//   int direction = 0;
//   bool _isFrontCamera = false;

//   // ? Capture
//   bool isCapturing = false;

//   // ? Flash
//   bool isFlashOn = false;

//   // ? Focus
//   Offset? _focusPoint;

//   // ? Zoom
//   double _currentZoom = 1.0;

//   // ? File
//   File? _captureImage;

//   @override
//   void initState() {
//     super.initState();
//     initializeCamera();
//   }

//   void initializeCamera() async {
//     cameras = await availableCameras();
//     cameraController = CameraController(
//       cameras[direction],
//       ResolutionPreset.high,
//       enableAudio: false,
//     );
//     cameraController!.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {
//         isCameraReady = true;
//       });
//     }).catchError((error) {
//       print('Failed to initialize camera: ${error}');
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     cameraController?.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!isCameraReady) {
//       return Container();
//     }
//     // return SafeArea(
//     //   child: Scaffold(
//     //     body: LayoutBuilder(
//     //       builder: (BuildContext context, BoxConstraints constraints) {
//     //         return Stack(
//     //           children: [
//     //             //TODO: [Top Bar]
//     //             Positioned(
//     //               top: 0,
//     //               left: 0,
//     //               right: 0,
//     //               child: Container(
//     //                 height: 50,
//     //                 decoration: BoxDecoration(
//     //                   color: Colors.black,
//     //                 ),
//     //                 child: Row(
//     //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //                   children: [
//     //                     Padding(
//     //                       padding: EdgeInsets.all(10.0),
//     //                       child: GestureDetector(
//     //                         onTap: () {
//     //                           _toggleFlashLight();
//     //                         },
//     //                         child: isFlashOn == false
//     //                             ? Icon(
//     //                                 Icons.flash_off_outlined,
//     //                                 color: Colors.white,
//     //                               )
//     //                             : Icon(
//     //                                 Icons.flash_on,
//     //                                 color: Colors.white,
//     //                               ),
//     //                       ),
//     //                     ),
//     //                     Padding(
//     //                       padding: const EdgeInsets.all(10.0),
//     //                       child: GestureDetector(
//     //                         onTap: () {},
//     //                         child: Icon(
//     //                           Icons.qr_code_scanner_rounded,
//     //                           color: Colors.white,
//     //                         ),
//     //                       ),
//     //                     ),
//     //                   ],
//     //                 ),
//     //               ),
//     //             ),

//     //             Stack(
//     //               children: [
//     //                 Positioned.fill(
//     //                   top: 50,
//     //                   // bottom: _isFrontCamera == false ? 0 : 150,
//     //                   child: AspectRatio(
//     //                     aspectRatio: cameraController!.value.aspectRatio,
//     //                     child: GestureDetector(
//     //                       onTapDown: (TapDownDetails details) {
//     //                         final Offset tapPosition = details.localPosition;
//     //                         final Offset relativeTapPosition = Offset(
//     //                             tapPosition.dx / constraints.maxWidth,
//     //                             tapPosition.dy / constraints.maxHeight);
//     //                         _setFocusPoint(relativeTapPosition);
//     //                       },
//     //                       child: CameraPreview(
//     //                         cameraController!,
//     //                         child: Align(
//     //                           alignment: Alignment.center,
//     //                           child: Padding(
//     //                             padding: EdgeInsets.symmetric(horizontal: 50),
//     //                             child: Image(
//     //                               image: AssetImage(
//     //                                 "assets/images/_project/Icons/Frame/overlay_frame.png",
//     //                               ),
//     //                               fit: BoxFit.contain,
//     //                               width: 350,
//     //                             ),
//     //                           ),
//     //                         ),
//     //                       ),
//     //                     ),
//     //                   ),
//     //                 ),
//     //               ],
//     //             ),

//     //             // TODO: [Zoom]
//     //             Positioned(
//     //               top: 50,
//     //               right: 10,
//     //               child: SfSlider.vertical(
//     //                   max: 5.0,
//     //                   min: 1.0,
//     //                   activeColor: Colors.white,
//     //                   value: _currentZoom,
//     //                   onChanged: (dynamic value) {
//     //                     setState(() {
//     //                       zoomCamera(value);
//     //                     });
//     //                   }),
//     //             ),
//     //             //TODO [Focus]
//     //             if (_focusPoint != null)
//     //               Positioned.fill(
//     //                 top: 50,
//     //                 child: Align(
//     //                   alignment: Alignment(
//     //                       _focusPoint!.dx * 2 - 1, _focusPoint!.dy * 2 - 1),
//     //                   child: Container(
//     //                     height: 80,
//     //                     width: 80,
//     //                     decoration: BoxDecoration(
//     //                         border: Border.all(color: Colors.white, width: 2)),
//     //                   ),
//     //                 ),
//     //               ),

//     //             //TODO: [Title Bar]
//     //             Positioned(
//     //               bottom: 0,
//     //               left: 0,
//     //               right: 0,
//     //               child: Container(
//     //                 height: 150,
//     //                 decoration: BoxDecoration(
//     //                     color: _isFrontCamera == false
//     //                         ? Colors.black45
//     //                         : Colors.black),
//     //                 child: Column(
//     //                   children: [
//     //                     Padding(
//     //                       padding: const EdgeInsets.all(10.0),
//     //                       child: Row(
//     //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     //                         children: [
//     //                           titleBar('Video'),
//     //                           titleBar('Photo'),
//     //                           titleBar('Pro Mode'),
//     //                         ],
//     //                       ),
//     //                     ),
//     //                     Expanded(
//     //                       child: Column(
//     //                         mainAxisAlignment: MainAxisAlignment.center,
//     //                         children: [
//     //                           Row(
//     //                             children: [
//     //                               Expanded(
//     //                                 child: Row(
//     //                                   mainAxisAlignment:
//     //                                       MainAxisAlignment.center,
//     //                                   children: [
//     //                                     _captureImage != null
//     //                                         ? Container(
//     //                                             width: 50,
//     //                                             height: 50,
//     //                                             child: Image.file(
//     //                                               _captureImage!,
//     //                                               fit: BoxFit.cover,
//     //                                             ),
//     //                                           )
//     //                                         : Container(),
//     //                                   ],
//     //                                 ),
//     //                               ),
//     //                               Expanded(
//     //                                 child: GestureDetector(
//     //                                   onTap: () {
//     //                                     capturePhoto();
//     //                                   },
//     //                                   child: Center(
//     //                                     child: Container(
//     //                                       height: 70,
//     //                                       width: 70,
//     //                                       decoration: BoxDecoration(
//     //                                         color: Colors.transparent,
//     //                                         borderRadius:
//     //                                             BorderRadius.circular(50),
//     //                                         border: Border.all(
//     //                                             width: 4,
//     //                                             color: Colors.white,
//     //                                             style: BorderStyle.solid),
//     //                                       ),
//     //                                     ),
//     //                                   ),
//     //                                 ),
//     //                               ),
//     //                               Expanded(
//     //                                   child: GestureDetector(
//     //                                 onTap: () {
//     //                                   _switchCamera();
//     //                                 },
//     //                                 child: Icon(
//     //                                   Icons.cameraswitch_sharp,
//     //                                   color: Colors.white,
//     //                                   size: 40,
//     //                                 ),
//     //                               )),
//     //                             ],
//     //                           )
//     //                         ],
//     //                       ),
//     //                     ),
//     //                   ],
//     //                 ),
//     //               ),
//     //             ),
//     //             // CameraPreview(cameraController!),

//     //             //     onTap: () {
//     //             //       cameraController!.takePicture().then((XFile file) {
//     //             //         if (mounted) {
//     //             //           if (file != null) {
//     //             //             print('Picture stores to ${file.path}');
//     //             //           }
//     //             //         }
//     //             //       });
//     //             //     },
//     //             //     child: button(
//     //             //         Icons.camera_alt_outlined, Alignment.bottomCenter))
//     //           ],
//     //         );
//     //       },
//     //     ),
//     //   ),
//     // );
//     return SafeArea(
//       child: Scaffold(
//         body: LayoutBuilder(
//           builder: (BuildContext context, BoxConstraints constraints) {
//             return Stack(
//               children: [
//                 // TODO: [Top Bar]
//                 Positioned(
//                   top: 0,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: Colors.black,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.all(10.0),
//                           child: GestureDetector(
//                             onTap: () {
//                               _toggleFlashLight();
//                             },
//                             child: isFlashOn == false
//                                 ? Icon(
//                                     Icons.flash_off_outlined,
//                                     color: Colors.white,
//                                   )
//                                 : Icon(
//                                     Icons.flash_on,
//                                     color: Colors.white,
//                                   ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: GestureDetector(
//                             onTap: () {},
//                             child: Icon(
//                               Icons.qr_code_scanner_rounded,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Stack(
//                   children: [
//                     Positioned.fill(
//                       top: 50,
//                       child: AspectRatio(
//                         aspectRatio: cameraController!.value.aspectRatio,
//                         child: GestureDetector(
//                           onTapDown: (TapDownDetails details) {
//                             final Offset tapPosition = details.localPosition;
//                             final Offset relativeTapPosition = Offset(
//                                 tapPosition.dx / constraints.maxWidth,
//                                 tapPosition.dy / constraints.maxHeight);
//                             _setFocusPoint(relativeTapPosition);
//                           },
//                           child: CameraPreview(
//                             cameraController!,
//                             child: Stack(
//                               children: [
//                                 Align(
//                                   alignment: Alignment.center,
//                                   child: Padding(
//                                     padding: EdgeInsets.only(
//                                         bottom: 190), // Dịch lên trên
//                                     child: Image(
//                                       image: AssetImage(
//                                         "assets/images/_project/Icons/Frame/overlay_frame.png",
//                                       ),
//                                       fit: BoxFit.contain,
//                                       width: 270,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 // TODO: [Zoom]
//                 Positioned(
//                   bottom: 160, // Dịch lên trên phần điều khiển chụp ảnh
//                   left: 20,
//                   right: 20,
//                   child: Slider(
//                     value: _currentZoom,
//                     min: 1.0,
//                     max: 5.0,
//                     activeColor: Colors.white,
//                     onChanged: (value) {
//                       setState(() {
//                         zoomCamera(value);
//                       });
//                     },
//                   ),
//                 ),
//                 //TODO [Focus]
//                 if (_focusPoint != null)
//                   Positioned.fill(
//                     top: 50,
//                     child: Align(
//                       alignment: Alignment(
//                           _focusPoint!.dx * 2 - 1, _focusPoint!.dy * 2 - 1),
//                       child: Container(
//                         height: 80,
//                         width: 80,
//                         decoration: BoxDecoration(
//                             border: Border.all(color: Colors.white, width: 2)),
//                       ),
//                     ),
//                   ),
//                 // TODO: [Title Bar]
//                 Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     height: 150,
//                     decoration: BoxDecoration(
//                         color: _isFrontCamera == false
//                             ? Colors.black45
//                             : Colors.black),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               titleBar('Video'),
//                               titleBar('Photo'),
//                               titleBar('Pro Mode'),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         _captureImage != null
//                                             ? Container(
//                                                 width: 50,
//                                                 height: 50,
//                                                 child: Image.file(
//                                                   _captureImage!,
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               )
//                                             : Container(),
//                                       ],
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         capturePhoto();
//                                       },
//                                       child: Center(
//                                         child: Container(
//                                           height: 70,
//                                           width: 70,
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             borderRadius:
//                                                 BorderRadius.circular(50),
//                                             border: Border.all(
//                                                 width: 4,
//                                                 color: Colors.white,
//                                                 style: BorderStyle.solid),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         _switchCamera();
//                                       },
//                                       child: Icon(
//                                         Icons.cameraswitch_sharp,
//                                         color: Colors.white,
//                                         size: 40,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Expanded titleBar(String tag) {
//     return Expanded(
//       child: Center(
//         child: Text(
//           tag,
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget button(IconData icon, Alignment alignment) {
//     return Align(
//       alignment: alignment,
//       child: Container(
//         height: 50,
//         width: 50,
//         margin: EdgeInsets.only(left: 20, right: 20),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black26,
//               offset: Offset(2, 2),
//               blurRadius: 20,
//             )
//           ],
//         ),
//         child: Center(
//           child: Icon(
//             icon,
//             color: Colors.black,
//           ),
//         ),
//       ),
//     );
//   }

//   void _toggleFlashLight() {
//     if (isFlashOn) {
//       cameraController!.setFlashMode(FlashMode.off);
//       setState(() {
//         isFlashOn = false;
//       });
//     } else {
//       cameraController!.setFlashMode(FlashMode.torch);
//       setState(() {
//         isFlashOn = true;
//       });
//     }
//   }

//   void _switchCamera() async {
//     if (cameraController != null) {
//       await cameraController!.dispose();
//     }
//     direction = direction == 0 ? 1 : 0;
//     _isFrontCamera = direction == 0 ? false : true;
//     initializeCamera();
//   }

//   void capturePhoto() async {
//     if (!cameraController!.value.isInitialized) {
//       return;
//     }
//     final Directory appDir = await pathProvider.getApplicationCacheDirectory();
//     final String capturePath = path.join(appDir.path, '${DateTime.now()}.jpg');

//     if (cameraController!.value.isTakingPicture) {
//       return;
//     }

//     try {
//       setState(() {
//         isCapturing = true;
//       });

//       final XFile captureImage = await cameraController!.takePicture();
//       String imagePath = captureImage.path;
//       await GallerySaver.saveImage(imagePath);
//       print("Photo captured and saved to gallery");

//       //For showing image
//       final String filePath =
//           '$capturePath/${DateTime.now().microsecondsSinceEpoch}.jpg';
//       _captureImage = File(captureImage.path);
//       _captureImage!.renameSync(filePath);
//     } catch (e) {
//       print("Error capturing photo $e");
//     } finally {
//       setState(() {
//         isCapturing = false;
//       });
//     }
//   }

//   void zoomCamera(value) {
//     setState(() {
//       _currentZoom = value;
//       cameraController!.setZoomLevel(value);
//     });
//   }

//   Future<void> _setFocusPoint(Offset relativeTapPosition) async {
//     if (cameraController != null && cameraController!.value.isInitialized) {
//       try {
//         final double x = relativeTapPosition.dx.clamp(0.0, 1.0);
//         final double y = relativeTapPosition.dy.clamp(0.0, 1.0);
//         await cameraController!.setFocusPoint(Offset(x, y));
//         await cameraController!.setFocusMode(FocusMode.auto);
//         setState(() {
//           _focusPoint = Offset(x, y);
//         });
//         //Reset focuspoint after a short delay
//         await Future.delayed(Duration(seconds: 2));
//         setState(() {
//           _focusPoint = null;
//         });
//       } catch (e) {
//         print('Fail to focus $e');
//       }
//     }
//   }
// }
