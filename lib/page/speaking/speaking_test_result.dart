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
  bool isPlaying = false; // Track the playing state
  double playbackProgress = 0.0; // Track playback progress

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
        const SnackBar(content: Text('No recording found to play')),
      );
    }
  }

  void _submitTest() {
    // Hiển thị pop-up xác nhận
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Test'),
        content: const Text('Are you sure you want to submit the test?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Test Submitted'),
                  content: const Text(
                    'Thank you for taking the test.\nYour answers have been saved. We will send you the result soon.',
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: const Text('Back to home'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Yes', style: TextStyle(color: Colors.green),),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng pop-up xác nhận
            },
            child: const Text('No', style: TextStyle(color: Colors.red),),
          ),
        ],
      ),
    );
  }
  void _stopPlayback() {
    // Replace with actual stop playback logic
    // Example:
    // audioPlayer.stop();
    setState(() {
      isPlaying = false;
      playbackProgress = 0.0;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speaking Test Result'),
        backgroundColor: const Color(0xFFB5E0EA),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            const Text(
              'Congratulations on completing the test!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer),
                const SizedBox(width: 8),
                _buildCompletionTimeText(widget.completionTime),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Your Recording:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (widget.recordedFilePath.isNotEmpty)
              Column(
                children: [
                  IconButton(
                    icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
                    iconSize: 64,
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        isPlaying = !isPlaying;
                        if (isPlaying) {
                          _playRecording();
                        } else {
                          // Call function to stop playback
                          _stopPlayback();
                        }
                      });
                    },
                  ),
                  if (isPlaying)
                    LinearProgressIndicator(
                      value: playbackProgress,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                ],
              )
            else
              const Text(
                'No recording available.',
                style: TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 32),
            const Spacer(),
            ElevatedButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.green),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: _submitTest,
              child: const Text('Submit Test'),
            ),
          ],
        ),
      ),
    );
  }

  Text _buildCompletionTimeText(String completionTime) {
    RegExp regex = RegExp(r'\d+');
    RegExpMatch? match = regex.firstMatch(completionTime);
    int timeInMinutes = match != null ? int.parse(match.group(0)!) : 0;

    int timeDifference = timeInMinutes - 10; // Assuming initial time is 10 minutes
    String text;
    if (timeDifference > 0) {
      text = 'Completed in $timeDifference minutes extra.';
    } else if (timeDifference < 0) {
      text = 'Completed ${-timeDifference} minutes early.';
    } else {
      text = 'Completed on time.';
    }
    return Text(text, style: const TextStyle(fontSize: 18));
  }
}
