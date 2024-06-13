import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'speaking_test_result.dart'; // Corrected import path

class SpeakingQuestionPage extends StatefulWidget {
  final String testName;
  final String part;
  final String selectedTime;
  final Map<String, dynamic> speakingData;

  SpeakingQuestionPage({
    required this.testName,
    required this.part,
    required this.selectedTime,
    required this.speakingData,
  });

  @override
  _SpeakingQuestionPageState createState() => _SpeakingQuestionPageState();
}

class _SpeakingQuestionPageState extends State<SpeakingQuestionPage> {
  late List<String> _questions;
  int _currentQuestionIndex = 0;
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _recordingPath;
  Timer? _timer;
  Duration _remainingTime = Duration();
  bool _isTestCompleted = false;
  Map<String, dynamic> _answers = {};

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _initRecorder();
    _startTimer();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _timer?.cancel();
    super.dispose();
  }

  void _loadQuestions() {
    setState(() {
      _questions = _getQuestions(
          widget.speakingData[widget.part.toLowerCase().replaceAll(' ', '_')] ??
              {});
    });
  }

  List<String> _getQuestions(Map<String, dynamic> partData) {
    List<String> questions = [];
    partData.forEach((key, value) {
      if (key.startsWith('q') && value != null) {
        questions.add(value as String);
      }
    });
    return questions;
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _isTestCompleted = true;
        _stopRecording();
        _saveAnswersToJson();
        _navigateToSpeakingResult();
      }
    });
  }

  void _initRecorder() async {
    await _recorder.openRecorder();
    await _recorder.setSubscriptionDuration(Duration(milliseconds: 10));
  }

  void _startRecording() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Microphone permission is required')),
      );
      return;
    }

    Directory tempDir = await getTemporaryDirectory();
    _recordingPath = '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recorder.startRecorder(toFile: _recordingPath);
    setState(() {
      _isRecording = true;
    });
  }

  void _stopRecording() async {
    if (_isRecording) {
      await _recorder.stopRecorder();
      setState(() {
        _isRecording = false;
      });

      if (_recordingPath != null) {
        _answers['ans${widget.part.substring(5)}'] = _recordingPath;
      }
    }
  }

  void _startTimer() {
    final timeParts = widget.selectedTime.split(' ');
    final minutes = int.tryParse(timeParts.first) ?? 0;

    _remainingTime = Duration(minutes: minutes);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = _remainingTime - Duration(seconds: 1);
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you want to exit test?'),
        content: Text('Warning: If you exit, the result will not be saved.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              _stopRecording();
              _saveAnswersToJson();
              Navigator.of(context).pop(true);
            },
            child: Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;
  }

  void _saveAnswersToJson() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/speaking_answers.json';

    Map<String, dynamic> jsonData = {};
    if (File(filePath).existsSync()) {
      String jsonString = await File(filePath).readAsString();
      jsonData = jsonDecode(jsonString);
    }

    String testName = widget.testName.toLowerCase().replaceAll(' ', '_');
    if (!jsonData.containsKey(testName)) {
      jsonData[testName] = {};
    }

    String partName = widget.part.toLowerCase().replaceAll(' ', '_');
    if (!jsonData[testName].containsKey(partName)) {
      jsonData[testName][partName] = {};
    }

    _answers.forEach((key, value) {
      jsonData[testName][partName][key] = value;
    });

    File file = File(filePath);
    await file.writeAsString(jsonEncode(jsonData));
  }

  void _navigateToSpeakingResult() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SpeakingTestResultPage(
          recordedFilePath: _answers['ans${widget.part.substring(5)}'] ?? '',
          completionTime: widget.selectedTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timer),
              SizedBox(width: 4),
              Text(
                '${_remainingTime.inMinutes}:${(_remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          backgroundColor: Color(0xFFB5E0EA),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.testName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black26),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${_currentQuestionIndex + 1}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      _questions.isNotEmpty
                          ? Center(
                        child: Text(
                          _questions[_currentQuestionIndex],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                          : Text(
                        'No questions available for this part.',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              _isTestCompleted
                  ? Column(
                children: [
                  Text(
                    'Review your recording:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  // Replace this with your actual recording playback widget
                  Text('Your recording will be shown here'),
                ],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Audio Waveform (Left)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        size: 30,
                      ),
                      onPressed: _isRecording ? _stopRecording : _startRecording,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Audio Waveform (Right)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isTestCompleted ? null : _nextQuestion,
                child: Text(_isTestCompleted ? 'Submit Test' : 'Next Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
