import 'package:flutter/material.dart';
import 'package:ielts_practice_flutter_application/page/listening/listening_list_test.dart';
import 'package:ielts_practice_flutter_application/page/reading/reading_list_test.dart';
import 'package:ielts_practice_flutter_application/page/writing/writing_list_test.dart';
import 'package:ielts_practice_flutter_application/page/speaking/speaking_list_test.dart';

class HomePage extends StatefulWidget {
  @override
  _IELTSHomeState createState() => _IELTSHomeState();
}

class _IELTSHomeState extends State<HomePage> {
  bool isAcademic = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IELTS', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.amber),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isAcademic = true;
                        });
                      },
                      child: Column(
                        children: [
                          Icon(Icons.school, color: isAcademic ? Colors.blue : Colors.grey),
                          Text('Academic', style: TextStyle(color: isAcademic ? Colors.blue : Colors.grey)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isAcademic = false;
                        });
                      },
                      child: Column(
                        children: [
                          Icon(Icons.public, color: !isAcademic ? Colors.orange : Colors.grey),
                          Text('General', style: TextStyle(color: !isAcademic ? Colors.orange : Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  isAcademic
                      ? '"Start with a clear purpose in mind, keep your sentences concise, and revise for clarity."'
                      : '"Master IELTS Academic: Open Doors to Global Success!"',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: isAcademic
                  ? [
                _buildGridItem(Icons.headset, 'Listening Test', ListeningListTestPage()),
                _buildGridItem(Icons.book, 'Reading Test', ReadingListTestPage()),
                _buildGridItem(Icons.edit, 'Writing Test', WritingListTestPage()),
                _buildGridItem(Icons.mic, 'Speaking Test', SpeakingListTestPage()),
                _buildGridItem(Icons.all_inclusive, 'Full Skills', null),
                _buildGridItem(Icons.spellcheck, 'Grammar', null),
              ]
                  : [
                _buildGridItem(Icons.headset, 'Listening Practice', ListeningListTestPage()),
                _buildGridItem(Icons.book, 'Reading Practice', ReadingListTestPage()),
                _buildGridItem(Icons.edit, 'Writing Practice', WritingListTestPage()),
                _buildGridItem(Icons.mic, 'Speaking Practice', SpeakingListTestPage()),
                _buildGridItem(Icons.all_inclusive, 'General Skills', null),
                _buildGridItem(Icons.spellcheck, 'Grammar Practice', null),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String label, Widget? page) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 4,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              SizedBox(height: 8),
              Text(label, style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),
      ),
    );
  }
}
