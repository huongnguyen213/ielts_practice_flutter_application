import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ielts_practice_flutter_application/page/full_skill/test_result.dart';
import 'widgets/WritingContentWidget.dart';

class DetailTest extends StatefulWidget {
  @override
  _DetailTestState createState() => _DetailTestState();
}

class _DetailTestState extends State<DetailTest> {
  final List<Tab> tabs = [
    Tab(text: 'Speaking'),
    Tab(text: 'Listening'),
    Tab(text: 'Reading'),
    Tab(text: 'Writing'),
  ];

  Duration remainingTime = Duration(hours: 2, minutes: 45); // Updated duration
  late Timer timer;

  Map<String, dynamic>? writingData; // To store the parsed JSON data

  @override
  void initState() {
    super.initState();
    startTimer();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    final String response = await rootBundle.loadString('lib/assets/data/full_skill.json');
    final data = await json.decode(response);

    setState(() {
      writingData = data['ielts']['test_1']['writing'];
    });
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
                _submitTest();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _submitTest() {
    // Handle test submission logic here
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TestResult()), // Example replacement widget
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
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
              Text(formatDuration(remainingTime)),
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
          bottom: TabBar(
            tabs: tabs,
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Content for Speaking tab')),
            Center(child: Text('Content for Listening tab')),
            Center(child: Text('Content for Reading tab')),
            writingData == null
                ? Center(child: CircularProgressIndicator())
                : WritingContentWidget(
              part1Data: writingData!['part_1'],
              part2Data: writingData!['part_2'],
              remainingTime: remainingTime,
            ),
          ],
        ),
      ),
    );
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
                    Navigator.of(context).pop();
                  },
                  child: Text('No'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _submitTest();
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
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }
}
