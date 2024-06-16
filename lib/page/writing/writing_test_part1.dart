import 'package:flutter/material.dart';
import 'package:ielts_practice_flutter_application/page/writing/writing_result.dart';
import 'take_picture_part1.dart';
import 'dart:async';

class WritingTestPart1Page extends StatefulWidget {
  final String testTitle;
  final Map<String, dynamic> testPartData;
  final String selectedPart;
  final String selectedTime;

  WritingTestPart1Page({
    required this.testTitle,
    required this.testPartData,
    required this.selectedPart,
    required this.selectedTime,
  });

  @override
  _WritingTestPart1PageState createState() => _WritingTestPart1PageState();
}

class _WritingTestPart1PageState extends State<WritingTestPart1Page> {
  late Duration remainingTime;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    remainingTime = parseSelectedTime(widget.selectedTime);
    startTimer();
  }

  Duration parseSelectedTime(String selectedTime) {
    try {
      RegExp regex = RegExp(r'(\d+)\s*minutes');
      Match? match = regex.firstMatch(selectedTime);
      if (match != null) {
        int minutes = int.parse(match.group(1)!);
        return Duration(minutes: minutes);
      }
    } catch (e) {
      print('Error parsing selected time: $e');
    }
    return Duration(minutes: 0);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final halfHeight = constraints.maxHeight / 2;
          return Column(
            children: [
              Container(
                height: halfHeight,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Part 1: ' + widget.testPartData['note'],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(widget.testPartData['q1']),
                        SizedBox(height: 10),
                        Image.asset(widget.testPartData['img']),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      hintText: 'Your answer...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    _captureImageFromCamera(context);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _captureImageFromCamera(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TakePictureScreen(remainingTime: remainingTime)),
    ).then((imagePath) {
      if (imagePath != null) {
        widget.testPartData['capturedImage'] = imagePath;
      }
    });
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
