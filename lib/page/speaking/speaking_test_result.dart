import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SpeakingTestResultPage extends StatefulWidget {
  final String recordedFilePath;
  final String completionTime;

  SpeakingTestResultPage({
    required this.recordedFilePath,
    required this.completionTime,
  });

  @override
  _SpeakingTestResultPageState createState() => _SpeakingTestResultPageState();
}

class _SpeakingTestResultPageState extends State<SpeakingTestResultPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playRecording() async {
    if (widget.recordedFilePath.isNotEmpty) {
      await _audioPlayer.setFilePath(widget.recordedFilePath);
      await _audioPlayer.play();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No recording found to play')),
      );
    }
  }

  void _submitTest() {
    // Simulate submitting test logic here
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Test Submitted'),
        content: Text(
          'Your answers have been saved. We will send you the result soon <3',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text('Home'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speaking Test Result'),
        backgroundColor: Color(0xFFB5E0EA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Congratulations on completing the test!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Completion Time: ${widget.completionTime}',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Text(
              'Your Recording:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            if (widget.recordedFilePath.isNotEmpty)
              ElevatedButton(
                onPressed: _playRecording,
                child: Text('Play Recording'),
              )
            else
              Text(
                'No recording available.',
                style: TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitTest,
              child: Text('Submit Test'),
            ),
          ],
        ),
      ),
    );
  }
}
