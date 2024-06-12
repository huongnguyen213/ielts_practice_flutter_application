import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PopUpSpeakingSetUpTest extends StatefulWidget {
  @override
  _PopUpSpeakingSetUpTestState createState() => _PopUpSpeakingSetUpTestState();
}

class _PopUpSpeakingSetUpTestState extends State<PopUpSpeakingSetUpTest> {
  String _selectedPart = 'Part 1';
  String _selectedTime = 'No limit';
  List<String> _times = ['No limit', '10 minutes', '13 minutes'];

  void _startTest() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      // Code to start the test
      Navigator.of(context).pop(); // Close the dialog
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Microphone permission granted. Starting test...'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Microphone permission denied.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          'Set Up Test',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Choose part',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
              Text(
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
      actions: [
        Center(
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.green,
              side: BorderSide(color: Colors.green),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text('Start'),
            onPressed: _startTest,
          ),
        ),
      ],
    );
  }
}
