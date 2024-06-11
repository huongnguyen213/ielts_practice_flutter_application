import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpeakingListTestPage extends StatefulWidget {
  @override
  _SpeakingListTestPageScreenState createState() =>
      _SpeakingListTestPageScreenState();
}

class _SpeakingListTestPageScreenState extends State<SpeakingListTestPage> {
  double _progress = 0.0;
  int _score = 0;
  bool _isFavorite = false;
  static SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _score = _prefs?.getInt('score') ?? 0;
      _isFavorite = _prefs?.getBool('isFavorite') ?? false;
    });
  }

  _saveScore(int score) async {
    await _prefs?.setInt('score', score);
  }

  _toggleFavorite(String testName) async {
    bool? currentFavorite = _prefs!.getBool(testName);
    bool newFavorite = currentFavorite != null ? !currentFavorite : false;
    await _prefs!.setBool(testName, newFavorite);
    setState(() {
      _isFavorite = newFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speaking Practice'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              Text(
                'Plan your essay structure before writing and ensure each paragraph has a clear main idea.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              _buildTestCard('Speaking Practice Test 1', 6),
              SizedBox(height: 16.0),
              _buildTestCard('Speaking Practice Test 2', 10),
              SizedBox(height: 16.0),
              _buildTestCard('Speaking Practice Test 3', 10),
              SizedBox(height: 16.0),
              _buildTestCard('Speaking Practice Test 4', 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestCard(String testName, int score) {
    bool isFavorite = _prefs?.getBool(testName) ?? false;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              testName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: score != null ? score / 10 : _progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: isFavorite ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: () {
                    _toggleFavorite(testName);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Score: ${score ?? _score}/10',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
