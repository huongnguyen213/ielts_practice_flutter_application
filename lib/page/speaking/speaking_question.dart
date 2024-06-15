import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:ielts_practice_flutter_application/page/speaking/speaking_test_result.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _recordingPath;
  Timer? _timer;
  Duration _remainingTime = const Duration();
  bool _isTestCompleted = false;
  final Map<String, dynamic> _answers = {};

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _initRecorder();
    _startTimer();
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
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
    _recorder = FlutterSoundRecorder();
    await _recorder!.openRecorder();
    await _recorder!.setSubscriptionDuration(
        const Duration(milliseconds: 10)
    );
  }

  void _startRecording() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission is required')),
      );
      return;
    }

    _recordingPath = 'audio_${DateTime
        .now()
        .millisecondsSinceEpoch}.aac';
    await _recorder!.startRecorder(toFile: _recordingPath);
    setState(() {
      _isRecording = true;
    });
  }

  void _stopRecording() async {
    if (_isRecording) {
      await _recorder!.stopRecorder();
      setState(() {
        _isRecording = false;
      });

      Directory? appDocDir = await getTemporaryDirectory();
      String? appDocPath = appDocDir!.path;
      String filePath = '$appDocPath/$_recordingPath';
      _answers['ans${widget.part.substring(5)}'] = filePath;
    }
  }

  void _startTimer() {
    final timeParts = widget.selectedTime.split(' ');
    final minutes = int.tryParse(timeParts.first) ?? 0;

    _remainingTime = Duration(minutes: minutes);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Do you want to exit test?', style: TextStyle(fontSize: 23),),
            content: const Text('Warning: If you exit, the result will not be saved.', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () {
                  _stopRecording();
                  _saveAnswersToJson();
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
    ) ?? false;
  }

  void _saveAnswersToJson() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/speaking.json';

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
        builder: (context) =>
            SpeakingTestResultPage(
              recordedFilePath: _answers['ans${widget.part.substring(5)}'] ??
                  '',
              completionTime: widget.selectedTime,
            ),
      ),
    );
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
              Navigator.of(context).pop(); // Đóng pop-up xác nhận
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng pop-up xác nhận
              // Hiển thị pop-up nộp bài thành công
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
                        _stopRecording(); // Dừng recorder
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: const Text('Home'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Yes'),
          ),
        ],
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
              const Icon(Icons.timer),
              const SizedBox(width: 4),
              Text(
                '${_remainingTime.inMinutes}:${(_remainingTime.inSeconds % 60)
                    .toString()
                    .padLeft(2, '0')}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFB5E0EA),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Text(
                widget.testName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 28),
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
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _questions.isNotEmpty
                          ? Center(
                        child: Text(
                          _questions[_currentQuestionIndex],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18),
                        ),
                      )
                          : const Text(
                        'No questions available for this part.',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _isTestCompleted
                  ? const Column(
                children: [
                  Text(
                    'Review your recording:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 28),
                  Text('Your recording will be shown here'),
                ],
              ) : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      width: 60,
                      child: const Icon(
                        Icons.graphic_eq,
                        size: 70,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(
                        _isRecording ? Icons.stop_circle_outlined: Icons.mic_outlined,
                        size: 60,
                        color: Colors.red,
                      ),
                      onPressed: _isRecording ? _stopRecording : _startRecording,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      width: 60,
                      child: const Icon(
                        Icons.graphic_eq,
                        size: 70,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isTestCompleted ? null : _nextQuestion,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color(0xFFB5E0EA),
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Color(0xFFB5E0EA)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(_isTestCompleted ? 'Submit Test' : 'Next Question', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}