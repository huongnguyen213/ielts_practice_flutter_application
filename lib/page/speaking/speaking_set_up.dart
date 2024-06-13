import 'package:flutter/material.dart';
import 'package:ielts_practice_flutter_application/page/speaking/speaking_instructions.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeakingSetUpTest extends StatefulWidget {
  final Map<String, dynamic> speakingData;

  SpeakingSetUpTest({required this.speakingData, required testName});

  @override
  _SpeakingSetUpTestState createState() => _SpeakingSetUpTestState();
}

class _SpeakingSetUpTestState extends State<SpeakingSetUpTest> {
  String _selectedPart = 'Part 1';
  String _selectedTime = 'No limit';
  final List<String> _times = ['No limit', '10 minutes', '15 minutes'];
  late String testName;

  @override
  void initState() {
    super.initState();
    testName = widget.speakingData['name'] ?? 'Unknown Test';
  }

  void _startTest() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SpeakingInstructions(
            part: _selectedPart,
            selectedTime: _selectedTime,
            speakingData: widget.speakingData,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Microphone permission denied.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text('Speaking Practice'),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Color(0xFFB5E0EA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Set Up Test',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    testName,
                    style: TextStyle(fontSize: 18.0, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choose part',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: const Text('Part 1'),
                      leading: Radio<String>(
                        value: 'Part 1',
                        groupValue: _selectedPart,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPart = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Part 2'),
                      leading: Radio<String>(
                        value: 'Part 2',
                        groupValue: _selectedPart,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPart = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Part 3'),
                      leading: Radio<String>(
                        value: 'Part 3',
                        groupValue: _selectedPart,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPart = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Full Part'),
                      leading: Radio<String>(
                        value: 'Full Part',
                        groupValue: _selectedPart,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPart = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Text(
                          'Choose time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: DropdownButton<String>(
                            value: _selectedTime,
                            isExpanded: true,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedTime = newValue!;
                              });
                            },
                            items: _times.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.green),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: _startTest,
                child: Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
