import 'package:flutter/material.dart';

class SpeakingDetails extends StatelessWidget {
  final String part;

  SpeakingDetails({required this.part});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Speaking Details'),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.blue[50],
              ),
              child: Text(
                part,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Instructions:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Your instructions go here. Explain what the user needs to do in this part of the test.',
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.red[50],
                      ),
                      child: const Text(
                        'Do not leave the test screen until you have completed all parts.',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50), // Increase button width
                  side: const BorderSide(color: Colors.green),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  // Start the test
                },
                child: const Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
