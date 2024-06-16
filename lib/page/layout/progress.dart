import 'package:flutter/material.dart';
import 'package:ielts_practice_flutter_application/page/layout/profile.dart';

import 'home_page.dart';

class ProgressPage extends StatefulWidget {
  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int _selectedIndex = 0;
  
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/img_cat.png",
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 32),
            const Text(
              'Practice History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildSkillCard('Listening', "icons/icons8-headphone-48.png"),
                _buildSkillCard('Speaking', "icons/icons8-mic-48.png"),
                _buildSkillCard('Reading', "icons/icons8-book-48.png"),
                _buildSkillCard('Writing', "icons/icons8-pencil-48.png")
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillCard(String skill, String iconPath) {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 40, height: 40),
          const SizedBox(height: 8),
          Text(skill, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
