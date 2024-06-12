import 'package:flutter/material.dart';
import 'package:ielts_practice_flutter_application/page/writing/writing_test_full_part.dart';
import 'package:ielts_practice_flutter_application/page/writing/writing_test_part1.dart';
import 'package:ielts_practice_flutter_application/page/writing/writing_test_part2.dart';

class WritingSetUpPage extends StatefulWidget {
  final Map<String, dynamic> writingData;

  WritingSetUpPage({required this.writingData});

  @override
  _WritingSetUpPageState createState() => _WritingSetUpPageState();
}

class _WritingSetUpPageState extends State<WritingSetUpPage> {
  String selectedPart = 'Full Part';
  String selectedTime = '15 minutes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Writing Practice '),
        backgroundColor: Color(0xFFB5E0EA),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Set up test',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Text('1. Choose part', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Part 1'),
                      leading: Radio(
                        value: 'Part 1',
                        groupValue: selectedPart,
                        onChanged: (value) {
                          setState(() {
                            selectedPart = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('Part 2'),
                      leading: Radio(
                        value: 'Part 2',
                        groupValue: selectedPart,
                        onChanged: (value) {
                          setState(() {
                            selectedPart = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              ListTile(
                title: Text('Full Part'),
                leading: Radio(
                  value: 'Full Part',
                  groupValue: selectedPart,
                  onChanged: (value) {
                    setState(() {
                      selectedPart = value!;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              Text('2. Choose time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Center(
                child: DropdownButton<String>(
                  value: selectedTime,
                  items: <String>[
                    '15 minutes',
                    '20 minutes',
                    '30 minutes',
                    '40 minutes',
                    '50 minutes',
                    '60 minutes',
                    'No limit'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedTime = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Widget nextPage;

                    switch (selectedPart) {
                      case 'Part 1':
                        nextPage = WritingTestPart1Page(
                          testTitle: widget.writingData['name'],
                          testPartData: widget.writingData['part_1'],
                          selectedPart: selectedPart,
                          selectedTime: selectedTime, // Pass selected time
                        );
                        break;
                      case 'Part 2':
                        nextPage = WritingTestPart2Page(
                          testTitle: widget.writingData['name'],
                          testPartData: widget.writingData['part_2'],
                          selectedPart: selectedPart,
                          selectedTime: selectedTime, // Pass selected time
                        );
                        break;
                      default:
                        nextPage = WritingTestFullPartPage(
                          testTitle: widget.writingData['name'],
                          part1Data: widget.writingData['part_1'],
                          part2Data: widget.writingData['part_2'],
                          selectedPart: selectedPart,
                          testPartData: {}, // Pass an empty map as testPartData for WritingTestFullPartPage
                          selectedTime: selectedTime, // Pass selected time
                        );
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => nextPage),
                    );
                  },
                  child: Text(
                    'Start',
                    style: TextStyle(
                      fontSize: 20, // Set the font size
                      fontWeight: FontWeight.bold, // Set the font weight
                      color: Colors.white, // Set the font color
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB5E0EA),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
