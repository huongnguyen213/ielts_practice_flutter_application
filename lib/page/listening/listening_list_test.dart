import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'listening_detail_fullpart.dart';
import 'listening_detail_part1.dart';
import 'listening_detail_part2.dart';
import 'listening_detail_part3.dart';
import 'listening_detail_part4.dart';
import 'test_set_up.dart';

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
  final List<String> imgList = [
    'lib/assets/images/tip-writing-1.png',
    'lib/assets/images/tip-writing-2.png',
    'lib/assets/images/tip-writing-3.png',
  ];
  int _currentIndex = 0;
  late PageController _pageController;
  late Timer _timer;
  SharedPreferences? _prefs;
  TextEditingController _searchController = TextEditingController();
  String dropdownValue = "All";
  List<MapEntry<String, dynamic>> filteredList = [];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
    _loadJson();
    _loadPreferences();
    _searchController.addListener(_filterTests);
    _timer = Timer.periodic(const Duration(seconds: 15), (Timer timer) {
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
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
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
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                imgList[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
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


  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lib/assets/data/listening.json');
    setState(() {
      tests = jsonDecode(jsonString)['listening'];
      tests = tests!.map((key, value) {
        bool isFavorite = _prefs?.getBool(key) ?? false;
        value['isFavorite'] = isFavorite;
        return MapEntry(key, value);
      });
      filteredList = tests!.entries.toList();
    });
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  void _filterTests() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredList = tests!.entries.where((entry) {
        bool matchesQuery = entry.key.toLowerCase().contains(query);
        bool matchesDropdown = dropdownValue == "All" || (dropdownValue == "Like" && entry.value['isFavorite']);
        return matchesQuery && matchesDropdown;
      }).toList();
    });
  }

  void _onDropdownChanged(String value) {
    setState(() {
      dropdownValue = value;
      _filterTests();
    });
  }

  _toggleFavorite(String testName) async {
    bool currentFavorite = _prefs!.getBool(testName) ?? false;
    bool newFavorite = !currentFavorite;
    await _prefs!.setBool(testName, newFavorite);

    setState(() {
      tests![testName]['isFavorite'] = newFavorite;
      _filterTests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffE2F1F4),
        title: Text('Listening Tests'),
      ),
      body: tests == null
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          buildCarouselSlider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 31,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(31),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 14),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              hintText: "Enter test name",
                              hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w200,
                                color: Colors.black,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Image.asset(
                          "assets/images/img_search.png",
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 14),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Container(
                  width: 130,
                  height: 31,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(31),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: Image.asset(
                        "assets/images/img_expand_arrow.png",
                        width: 40,
                        height: 40,
                      ),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.transparent,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          _onDropdownChanged(newValue);
                        }
                      },
                      items: <String>['All', 'Like']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                String testName = filteredList[index].key;
                var test = filteredList[index].value;
                int score = test['score'];
                bool isFavorite = test['isFavorite'] ?? false;

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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListeningTestSetupPage(testName),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.headset),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Listening $testName',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.star : Icons.star_border,
                                  color: Colors.yellow,
                                ),
                                onPressed: () {
                                  _toggleFavorite(testName);
                                },
                              ),
                            ],
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
  final String testName;

  ListeningTestSetupPage(this.testName);

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
              'Set up ${widget.testName}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Text(
              'Choose part:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
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
            SizedBox(height: 24),
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
                        builder: (context) => testSetup.selectedPart == "Part 1"
                            ? Part1Page(testSetup)
                            : testSetup.selectedPart == "Part 2"
                            ? Part2Page(testSetup)
                            : testSetup.selectedPart == "Part 3"
                            ? Part3Page(testSetup)
                            : testSetup.selectedPart == "Part 4"
                            ? Part4Page(testSetup)
                            : FullPartPage(testSetup),
                      ),
                    );
                  },
                  child: Text('Start',style:TextStyle(
                    fontSize: 20,
                    color: Colors.black,

                  ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffE2F1F4),
                  ),
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
