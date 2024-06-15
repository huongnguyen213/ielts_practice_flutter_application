import 'package:flutter/material.dart';
import 'package:ielts_practice_flutter_application/page/writing/take_picture_part2.dart';
import 'package:ielts_practice_flutter_application/page/writing/writing_result.dart';
import 'dart:async';

class WritingTestPart2Page extends StatefulWidget {
  final String testTitle;
  final Map<String, dynamic> testPartData;
  final String selectedPart;
  final String selectedTime;

  WritingTestPart2Page({
    required this.testTitle,
    required this.testPartData,
    required this.selectedPart,
    required this.selectedTime,
  });

  @override
  _WritingTestPart2PageState createState() => _WritingTestPart2PageState();
}

class _WritingTestPart2PageState extends State<WritingTestPart2Page> {
  late Duration remainingTime;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    // Parse selectedTime to get initial duration
    remainingTime = parseSelectedTime(widget.selectedTime);
    startTimer();
  }

  Duration parseSelectedTime(String selectedTime) {
    try {
      // Extract the number from the string, assuming the format is like "15 minutes"
      RegExp regex = RegExp(r'(\d+)\s*minutes');
      Match? match = regex.firstMatch(selectedTime);
      if (match != null) {
        int minutes = int.parse(match.group(1)!);
        return Duration(minutes: minutes);
      }
    } catch (e) {
      print('Error parsing selected time: $e');
    }
    // Default duration if parsing fails
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
            Text(formatDuration(remainingTime)), // Show remaining time here
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Part 2: ' + widget.testPartData['note'], // Display part 2 note
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(widget.testPartData['q2']), // Display part 2 question
                SizedBox(height: 10),
              ],
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
      ),
    );
  }

  void _captureImageFromCamera(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TakePictureScreen2(remainingTime: remainingTime,)),
    ).then((imagePath) {
      if (imagePath != null) {
        // Update the testPartData with the captured image path
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
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('No'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
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
