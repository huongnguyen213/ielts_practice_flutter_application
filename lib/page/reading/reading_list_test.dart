import 'package:flutter/material.dart';

class ReadingListTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reading Practice Tests'),
      ),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return TestSection(testNumber: index + 1);
        },
      ),
    );
  }
}

class TestSection extends StatelessWidget {
  final int testNumber;
  final int score = 9; // Example score, you can make this dynamic

  TestSection({required this.testNumber});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Reading Practice Test $testNumber'),
        subtitle: Text('Score: $score/10'),
        trailing: Icon(Icons.star, color: score == 10 ? Colors.green : null),
      ),
    );
  }
}
