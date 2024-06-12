import 'package:flutter/material.dart';

class SpeakingInstructions extends StatelessWidget {
  final String part;
  final String selectedTime;

  SpeakingInstructions({required this.part, required this.selectedTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instructions - $selectedTime'),
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
