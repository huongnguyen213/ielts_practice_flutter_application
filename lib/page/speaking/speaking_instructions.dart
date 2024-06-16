import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'speaking_question.dart';

class SpeakingInstructions extends StatelessWidget {
  final String part;
  final String selectedTime;
  final Map<String, dynamic> speakingData;

  SpeakingInstructions({required this.part, required this.selectedTime, required this.speakingData});

  String getInstructionContent(String part) {
    switch (part) {
      case 'Part 1':
        return "In this first part, the examiner will ask you some questions about yourself.\n\nDO NOT give out real personal information on your answers.";
      case 'Part 2':
        return "In this part you will be given a topic and you have 1-2 minutes to talk about it.\nBefore you talk, you have 1 minute to think about what you’re going to say, and you can make some notes if you wish.";
      case 'Part 3':
        return "In this part, you will be asked some more general questions based on the topic from part 2.";
      default:
        return "In this first part, the examiner will ask you some questions about yourself.\n\nDO NOT give out real personal information on your answers.";
    }
  }

  @override
  Widget build(BuildContext context) {
    String testName = speakingData['name'] ?? 'Unknown Test'; // Use null-aware operator to provide default value

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
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
            const SizedBox(width: 5),
            Text(selectedTime),
          ],
        ),
        elevation: 0,
        backgroundColor: const Color(0xFFB5E0EA),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.lightBlue[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                part,
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.lightBlue.shade50, width: 1.5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  const Text(
                    'INSTRUCTION',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    getInstructionContent(part),
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpeakingQuestionPage(
                      testName: testName, // Pass the testName from JSON
                      part: part,
                      selectedTime: selectedTime,
                      speakingData: speakingData,
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: const Color(0xFFB5E0EA),
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Color(0xFFB5E0EA)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Start',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
