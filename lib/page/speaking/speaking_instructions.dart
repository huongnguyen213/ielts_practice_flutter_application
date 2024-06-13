import 'package:flutter/material.dart';
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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            Icon(Icons.timer),
            SizedBox(width: 8),
            Text(selectedTime),
          ],
        ),
        elevation: 0,
        backgroundColor: Color(0xFFB5E0EA),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.lightBlue[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                part,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.lightBlue.shade50, width: 3.5),
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
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to SpeakingQuestionPage and pass part and selectedTime parameters
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
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB5E0EA),
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
