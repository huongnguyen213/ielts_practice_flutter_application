import 'package:flutter/material.dart';
import 'package:ielts_practice_flutter_application/page/listening/listening_detail_part4.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'listening_detail_fullpart.dart';
import 'listening_detail_part1.dart';
import 'listening_detail_part2.dart';
import 'listening_detail_part3.dart';
import 'test_set_up.dart';
import 'listening_detail_part1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListeningListTestPage(),
    );
  }
}

class ListeningListTestPage extends StatefulWidget {
  @override
  _ListeningListTestPageState createState() => _ListeningListTestPageState();
}

class _ListeningListTestPageState extends State<ListeningListTestPage> {
  Map<String, dynamic>? tests;
  SharedPreferences? _prefs;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadJson();
    _loadPreferences();
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lib/assets/data/listening.json');
    setState(() {
      tests = jsonDecode(jsonString)['listening'];
    });
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  _toggleFavorite(String testName) async {
    bool? currentFavorite = _prefs!.getBool(testName);
    bool newFavorite = currentFavorite != null ? !currentFavorite : true;
    await _prefs!.setBool(testName, newFavorite);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listening Tests'),

      ),
      body: tests == null
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Text(
              'Stay focused, practice regularly, and develop note-taking skills to excel in the IELTS listening test!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                // Implement search functionality here if needed
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tests!.length,
              itemBuilder: (context, index) {
                String testName = tests!.keys.elementAt(index);
                var test = tests![testName];
                int score = test['score'];
                bool isFavorite = _prefs?.getBool(testName) ?? false;

                return Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Listening $testName',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListeningTestSetupPage(testName),
                              ),
                            );
                          },
                          trailing: IconButton(
                            icon: Icon(
                              isFavorite ? Icons.star : Icons.star_border,
                              color: Colors.yellow,
                            ),
                            onPressed: () {
                              _toggleFavorite(testName);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: LinearProgressIndicator(
                            value: score / 10,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                          ),
                        ),
                        Text(
                          'Score: $score/10',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ListeningTestSetupPage extends StatefulWidget {
  late String testname;




  ListeningTestSetupPage(this.testname);

  @override
  _ListeningTestSetupPageState createState() => _ListeningTestSetupPageState();
}

class _ListeningTestSetupPageState extends State<ListeningTestSetupPage> {
  String _selectedPart = 'Part 1';
  String _selectedTime = 'Standard';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listening Test'),
        backgroundColor: Color(0xffE2F1F4),
      ),
      body: Container(
        margin: EdgeInsets.all(30),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Set up ${widget.testname}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Text(
              'Choose part:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
              childAspectRatio: 4.0,
              children: [
                _buildRadioTile('Part 1'),
                _buildRadioTile('Part 2'),
                _buildRadioTile('Part 3'),
                _buildRadioTile('Part 4'),
                _buildRadioTile('Full part'),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'Choose time:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              value: _selectedTime,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTime = newValue!;
                });
              },
              items: <String>['Standard', '15 minutes', '20 minutes']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    TestSetup testSetup = TestSetup(
                      selectedPart: _selectedPart,
                      selectedTime: _getTimeValue(_selectedTime),
                      isPlaying: true,

                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => testSetup.selectedPart == "Part 1" ?
                        Part1Page():
                            testSetup.selectedPart == "Part 2"? Part2Page(): testSetup.selectedPart == "Part 3" ?
                            Part3Page(): testSetup.selectedPart == "Part 4" ? Part4Page():
                            FullPartPage(),

                      ),
                    );
                  },
                  child: Text('Start'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioTile(String part) {
    return RadioListTile<String>(
      title: Text(part),
      value: part,
      groupValue: _selectedPart,
      onChanged: (value) {
        setState(() {
          _selectedPart = value!;
        });
      },
      contentPadding: EdgeInsets.all(0),
      dense: true,
    );
  }
}

int _getTimeValue(String timeLabel) {
  switch (timeLabel) {
    case 'Standard':
      return 10;
    case '15 minutes':
      return 15;
    case '20 minutes':
      return 20;
    default:
      return 0;
  }
}
