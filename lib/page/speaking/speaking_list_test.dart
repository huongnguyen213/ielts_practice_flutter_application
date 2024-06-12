import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ielts_practice_flutter_application/page/speaking/speaking_set_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpeakingListTestPage extends StatefulWidget {
  @override
  _SpeakingListTestPageState createState() => _SpeakingListTestPageState();
}

class _SpeakingListTestPageState extends State<SpeakingListTestPage> {
  final List<String> imgList = [
    'lib/assets/images/tip-writing-1.png',
    'lib/assets/images/tip-writing-2.png',
    'lib/assets/images/tip-writing-3.png',
  ];
  int _currentIndex = 0;
  static SharedPreferences? _prefs;
  late PageController _pageController;
  late Timer _timer;
  late Map<String, dynamic> parsedData = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(Duration(seconds: 15), (Timer timer) {
      if (_currentIndex < imgList.length - 1) {
        setState(() {
          _currentIndex++;
        });
      } else {
        setState(() {
          _currentIndex = 0;
        });
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });

    _loadData();
    loadJsonData();
  }

  Future<void> _loadData() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _toggleFavorite(String testName) async {
    bool currentFavorite = _prefs?.getBool(testName) ?? false;
    bool newFavorite = !currentFavorite;
    await _prefs?.setBool(testName, newFavorite);

    setState(() {
      parsedData[testName]['isFavorite'] = newFavorite;
    });
  }

  Future<void> loadJsonData() async {
    try {
      String jsonString = await rootBundle.loadString('lib/assets/data/speaking.json');
      Map<String, dynamic> jsonData = jsonDecode(jsonString)['speaking'];

      setState(() {
        parsedData = jsonData.map((key, value) {
          bool isFavorite = _prefs?.getBool(key) ?? false;
          value['isFavorite'] = isFavorite;
          return MapEntry(key, value);
        });
      });
    } catch (error) {
      print('Error loading JSON data: $error');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _onSpeakingItemPressed(String speakingKey, String testName) {
    if (parsedData.containsKey(speakingKey)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SpeakingSetUpTest(speakingData: parsedData[speakingKey], testName: testName),
        ),
      );
    }
  }

  Color _getProgressColor(int score) {
    if (score <= 4) {
      return Colors.red;
    } else if (score > 4 && score <= 6) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speaking Practice'),
        elevation: 0,
        backgroundColor: Color(0xFFB5E0EA),
      ),
      body: Column(
        children: [
          buildCarouselSlider(),
          Expanded(
            child: buildListView('Speaking Practice'),
          ),
        ],
      ),
    );
  }

  Widget buildCarouselSlider() {
    return Container(
      height: 200.0,
      padding: const EdgeInsets.all(10.0),
      child: PageView.builder(
        controller: _pageController,
        itemCount: imgList.length,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                imgList[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      'Image not found',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildListView(String part) {
    if (parsedData.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: parsedData.length,
      itemBuilder: (context, index) {
        String key = parsedData.keys.elementAt(index);
        var item = parsedData[key];
        int score = item['score'] is int ? item['score'] : 0;
        bool isFavorite = item['isFavorite'] ?? false;

        return GestureDetector(
          onTap: () {
            _onSpeakingItemPressed(key, item['name']);
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
            elevation: 4.0,
            color: Color(0xFFFFFFFF),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text((index + 1).toString()),
                ),
                title: Text(item['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: score / 10.0,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(score),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text('Score: ${score == 0 ? 'N/A' : score}/10'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: isFavorite ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: () {
                    _toggleFavorite(key);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
