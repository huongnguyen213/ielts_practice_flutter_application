import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class TakePictureScreen extends StatefulWidget {
  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  String? _capturedImagePath;

  @override
  void initState() {
    super.initState();
    _initCameras();
  }

  Future<void> _initCameras() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: false, // Không bật âm thanh khi chụp
        imageFormatGroup: ImageFormatGroup.jpeg, // Chọn định dạng ảnh JPEG
      );

      // Không bật flash tự động
      _cameraController!.setFlashMode(FlashMode.off);

      // Enable auto focus
      _cameraController!.setFocusMode(FocusMode.auto);

      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final image = await _cameraController!.takePicture();
        setState(() {
          _capturedImagePath = image.path;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double screenWidth = size.width;
    final double screenHeight = size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer),
            SizedBox(width: 5),
            Text('59 minutes'), // Show the remaining time here
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              // Add navigation action if needed
            },
          ),
        ],
        backgroundColor: Color(0xFFB5E0EA),
      ),
      body: Stack(
        children: [
          if (_isCameraInitialized || _capturedImagePath != null)
            Center(
              child: Container(
                width: screenWidth,
                height: screenWidth,
                child: ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Container(
                        width: screenWidth,
                        height: screenWidth,
                        child: _capturedImagePath == null
                            ? CameraPreview(_cameraController!)
                            : Image.file(
                          File(_capturedImagePath!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 20.0,
            left: (screenWidth - 50.0) / 2, // Center horizontally
            child: IconButton(
              icon: Icon(Icons.camera_alt, color: Color(0xFFB5E0EA)),
              onPressed: _captureImage,
              iconSize: 50,
            ),
          ),
        ],
      ),
    );
  }
}