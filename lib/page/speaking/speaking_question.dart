import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    setState(() {
      _questions = _getQuestions(widget.speakingData[widget.part.toLowerCase().replaceAll(' ', '_')] ?? {});
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('End of ${widget.part} questions')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.testName}'),
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
            Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.black26),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Question',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.black26),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _questions.isNotEmpty
                    ? Text(
                  _questions[_currentQuestionIndex],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                )
                    : Text(
                  'No questions available for this part.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _nextQuestion,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Color(0xFFB5E0EA),
              ),
              child: Text('Next Question', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Microphone button pressed logic here
        },
        backgroundColor: Color(0xFFB5E0EA),
        child: Icon(Icons.mic, size: 30),
      ),
    );
  }
}
