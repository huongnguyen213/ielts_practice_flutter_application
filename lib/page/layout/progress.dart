import 'package:flutter/material.dart';
import 'package:ielts_practice_flutter_application/page/layout/profile.dart';

import 'home_page.dart';

class ProgressPage extends StatefulWidget {
  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int _selectedIndex = 0;

  void _showReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Do you want to set up a study reminder?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showTimeSetupDialog(context);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProgressPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

  void _showTimeSetupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set up time'),
          content: const Text('You can set up the time here.'), // Add specific content if necessary
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CircleAvatar(
                  radius: 40,
                ),
                SizedBox(width: 16),
                Text(
                  'Progress',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Training History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildSkillCard('Listening', Icons.hearing),
                _buildSkillCard('Speaking', Icons.record_voice_over),
                _buildSkillCard('Reading', Icons.book),
                _buildSkillCard('Writing', Icons.edit),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () => _showReminderDialog(context),
                child: const Text('Set up study reminder'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillCard(String skill, IconData icon) {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 8),
          Text(skill, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
