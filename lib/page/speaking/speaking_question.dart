import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class SpeakingQuestionPage extends StatefulWidget {
  final String part;
  final int timeLimit;

  SpeakingQuestionPage({required this.part, required this.timeLimit});

  @override
  _SpeakingQuestionPageState createState() => _SpeakingQuestionPageState();
}

class _SpeakingQuestionPageState extends State<SpeakingQuestionPage> {
  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  bool _isThinking = true;
  Timer? _timer;
  int _remainingTime = 10; // Default think time

  @override
  void initState() {
    super.initState();
    _questions = [];
    _loadQuestions();
  }

  Future<List<Map<String, dynamic>>> _loadQuestions() async {
    final jsonString = await rootBundle.loadString('assets/data/speaking_questions.json');
    final data = json.decode(jsonString);
    final questions = List<Map<String, dynamic>>.from(data[widget.part.toLowerCase()]);
    return questions;
  }

  void _startTimer() {
    _timer?.cancel();
    _remainingTime = _isThinking ? 10 : widget.timeLimit * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        if (_isThinking) {
          setState(() {
            _isThinking = false;
            _startTimer();
          });
        } else {
          // Handle end of the test
        }
      }
    });
  }

  void _ignoreThinkingTime() {
    setState(() {
      _isThinking = false;
      _startTimer();
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _isThinking = true;
        _startTimer();
      });
    } else {
      // Handle end of the test
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text('Speaking Test'),
        ),
        centerTitle: false,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadQuestions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            _questions = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Question ${_currentQuestionIndex + 1}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          if (_isThinking)
                            Column(
                              children: [
                                Text(
                                  'Time to think: $_remainingTime seconds',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                                ),
                                SizedBox(height: 8.0),
                                TextButton(
                                  onPressed: _ignoreThinkingTime,
                                  child: Text('Ignore'),
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                Icon(Icons.mic, size: 40, color: Colors.green),
                                SizedBox(height: 8.0),
                                TextButton(
                                  onPressed: _nextQuestion,
                                  child: Text('Submit'),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _questions[_currentQuestionIndex]['question'],
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
