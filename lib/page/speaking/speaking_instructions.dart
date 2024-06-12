import 'package:flutter/material.dart';

class SpeakingInstructions extends StatelessWidget {
  final String part;
  final String selectedTime;

  SpeakingInstructions({required this.part, required this.selectedTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.timer), // Icon đồng hồ
            SizedBox(width: 8), // Khoảng cách giữa icon và text
            Text(selectedTime),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Instructions for $part\nSelected Time: $selectedTime',
          style: TextStyle(fontSize: 24.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
