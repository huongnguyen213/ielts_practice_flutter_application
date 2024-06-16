import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PopUpSpeakingSetUpTest extends StatefulWidget {
  @override
  _PopUpSpeakingSetUpTestState createState() => _PopUpSpeakingSetUpTestState();
}

class _PopUpSpeakingSetUpTestState extends State<PopUpSpeakingSetUpTest> {
  String _selectedPart = 'Part 1';
  String _selectedTime = 'No limit';
  final List<String> _times = ['No limit', '10 minutes', '13 minutes'];

  void _startTest() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      // Code to start the test
      Navigator.of(context).pop(); // Close the dialog
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Microphone permission granted. Starting test...'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Microphone permission denied.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text(
          'Set Up Test',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8.0),
          const Align(
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
          const SizedBox(height: 8.0),
          Row(
            children: [
              const Text(
                'Choose time',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16.0),
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
              side: const BorderSide(color: Colors.green),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: _startTest,
            child: const Text('Start'),
          ),
        ),
      ],
    );
  }
}
