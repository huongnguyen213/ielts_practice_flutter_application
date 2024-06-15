import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:ielts_practice_flutter_application/page/writing/writing_result.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class TakePictureScreen extends StatefulWidget {
  final Duration remainingTime;

  TakePictureScreen({required this.remainingTime});

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  String? _capturedImagePath;
  late Duration remainingTime;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.remainingTime;
    _initCameras();
    startTimer();
  }

  Future<void> _initCameras() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      _cameraController!.setFlashMode(FlashMode.off);
      _cameraController!.setFocusMode(FocusMode.auto);

      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime.inSeconds > 0) {
          remainingTime = Duration(seconds: remainingTime.inSeconds - 1);
        } else {
          timer.cancel();
          _showTimeUpDialog();
        }
      });
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Time is up!'),
          content: Text('Your time is over. Submitting the test.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WritingTestResult()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final image = await _cameraController!.takePicture();
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        await image.saveTo(imagePath);

        setState(() {
          _capturedImagePath = imagePath;
          _isCameraInitialized = false;
        });

        // Dispose of the camera controller
        await _cameraController?.dispose();
        _cameraController = null;

        await _updateJsonWithImagePath(imagePath);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _updateJsonWithImagePath(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final jsonFile = File('${directory.path}/writing_tests.json');

    if (await jsonFile.exists()) {
      final jsonData = json.decode(await jsonFile.readAsString());
      jsonData['writing']['test_1']['part_1']['ans'] = imagePath;
      await jsonFile.writeAsString(json.encode(jsonData));
    } else {
      print('JSON file does not exist');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double screenWidth = size.width;
    final double screenHeight = size.height - kToolbarHeight;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _capturedImagePath);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/img_clock.png",
              width: 40,
              height: 40,
            ),
            SizedBox(width: 5),
            Text(formatDuration(remainingTime)),
          ],
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'icons/icons8-right-button-40.png',
              width: 30,
              height: 30,
            ),
            onPressed: () {
              _showSubmitConfirmationDialog(context);
            },
          ),
        ],
        backgroundColor: Color(0xFFB5E0EA),
      ),
      body: Stack(
        children: [
          if (_isCameraInitialized && _capturedImagePath == null)
            Center(
              child: Container(
                width: screenWidth,
                height: screenHeight,
                child: ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Container(
                        width: screenWidth,
                        height: screenHeight,
                        child: CameraPreview(_cameraController!),
                      ),
                    ),
                  ),
                ),
              ),
            )
          else if (_capturedImagePath != null)
            Center(
              child: Image.file(
                File(_capturedImagePath!),
                width: screenWidth,
                height: screenHeight,
                fit: BoxFit.cover,
              ),
            )
          else
            Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 20.0,
            left: (screenWidth - 50.0) / 2,
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

  void _showSubmitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure to submit test?'),
          content: Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WritingTestResult()),
                    );
                  },
                  child: Text('Yes'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
