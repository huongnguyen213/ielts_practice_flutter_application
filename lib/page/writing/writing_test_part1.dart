import 'package:flutter/material.dart';
import 'take_picture_part1.dart';

class WritingTestPart1Page extends StatelessWidget {
  final String testTitle;
  final Map<String, dynamic> testPartData;
  final String selectedPart;
  final String selectedTime; // Add selectedTime

  WritingTestPart1Page({
    required this.testTitle,
    required this.testPartData,
    required this.selectedPart,
    required this.selectedTime, // Initialize selectedTime
  });

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
            Icon(Icons.timer),
            SizedBox(width: 5),
            Text(selectedTime), // Show selected time here
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Part 1: ' + testPartData['note'], // Display part 1 note
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(testPartData['q1']), // Display part 1 question
                SizedBox(height: 10),
                Image.asset(testPartData['img']), // Display part 1 image
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
      MaterialPageRoute(builder: (context) => TakePictureScreen()),
    ).then((imagePath) {
      if (imagePath != null) {
        // Update the testPartData with the captured image path
        testPartData['capturedImage'] = imagePath;
      }
    });
  }
}
