import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import 'writing_set_up_test.dart'; // Ensure this import points to the correct path

class WritingListTestPage extends StatefulWidget {
  @override
  _WritingListTestPageState createState() => _WritingListTestPageState();
}

class _WritingListTestPageState extends State<WritingListTestPage> {
  final List<String> imgList = [
    'lib/assets/images/tip-writing-1.png',
    'lib/assets/images/tip-writing-2.png',
    'lib/assets/images/tip-writing-3.png',
  ];
  int _currentIndex = 0;
  late PageController _pageController;
  late Timer _timer;

  late Map<String, dynamic> parsedData = {};
  List<MapEntry<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  String dropdownValue = "All";
  static SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(Duration(seconds: 15), (Timer timer) {
      if (_currentIndex < imgList.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });

    _loadData();
    loadJsonData();
    searchController.addListener(_filterTests);
  }

  Future<void> _loadData() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadJsonData() async {
    try {
      String jsonString = await rootBundle.loadString('lib/assets/data/writing.json');
      setState(() {
        parsedData = jsonDecode(jsonString)['writing'];
        parsedData = parsedData.map((key, value) {
          bool isFavorite = _prefs?.getBool(key) ?? false;
          value['isFavorite'] = isFavorite;
          return MapEntry(key, value);
        });
        filteredList = List.from(parsedData.entries);
      });
    } catch (error) {
      print('Error loading JSON data: $error');
    }
  }

  void _filterTests() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = parsedData.entries.where((entry) {
        bool matchesQuery = entry.value['name'].toLowerCase().contains(query);
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

  void _toggleFavorite(String testName) async {
    bool currentFavorite = _prefs?.getBool(testName) ?? false;
    bool newFavorite = !currentFavorite;
    await _prefs?.setBool(testName, newFavorite);

    setState(() {
      parsedData[testName]['isFavorite'] = newFavorite;
      _filterTests();
    });
  }

  void _onWritingItemPressed(String writingKey) {
    if (parsedData.containsKey(writingKey)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WritingSetUpPage(
            writingData: parsedData[writingKey],
            data: null,
          ),
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
        title: Text('Writing Practice'),
        elevation: 0,
        backgroundColor: Color(0xFFB5E0EA),
      ),
      body: SafeArea(
        child: Column(
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
                              controller: searchController,
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
                                hintText: "Enter writing name",
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
              child: buildListView(),
            ),
          ],
        ),
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

  Widget buildListView() {
    if (parsedData.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        String key = filteredList[index].key;
        var item = filteredList[index].value;
        int score = item['score'] is int ? item['score'] : 0;
        bool isFavorite = item['isFavorite'] ?? false;

        return GestureDetector(
          onTap: () {
            _onWritingItemPressed(key);
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
            elevation: 4.0,
            color: Color(0xFFFFFFFF),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.edit),
                ),
                title: Text(item['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: score / 10.0),
                      duration: Duration(milliseconds: 500),
                      builder: (context, value, child) {
                        return LinearProgressIndicator(
                          value: value,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getProgressColor(score),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    Text('Score: ${score == 0 ? '_' : score}/10'),
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
