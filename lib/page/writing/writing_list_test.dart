import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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

    loadJsonData(); // Gọi hàm để tải dữ liệu từ file JSON
  }

  Future<void> loadJsonData() async {
    try {
      String jsonString = await rootBundle.loadString('lib/assets/data/writing.json');
      setState(() {
        parsedData = jsonDecode(jsonString)['writing'];
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

  // Hàm xử lý sự kiện khi một bài viết được nhấn vào
  void _onWritingItemPressed(String writingKey) {
    // Kiểm tra xem có dữ liệu của bài viết được nhấn không
    if (parsedData.containsKey(writingKey)) {
      // Điều hướng sang trang bài viết chi tiết và truyền dữ liệu của bài viết cụ thể
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WritingSetUpPage(writingData: parsedData[writingKey]),
        ),
      );
    }
  }

  // Hàm để xác định màu sắc của LinearProgressIndicator dựa trên giá trị của score
  Color _getProgressColor(int score) {
    if (score <= 4) {
      return Colors.red; // Màu đỏ
    } else if (score > 4 && score <= 6) {
      return Colors.yellow; // Màu vàng
    } else {
      return Colors.green; // Màu xanh
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
      body: Column(
        children: [
          buildCarouselSlider(),
          Expanded(child: buildListView('Writing Practice')),
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
        return GestureDetector(
          onTap: () {
            // Gọi hàm xử lý sự kiện khi một bài viết được nhấn vào
            _onWritingItemPressed(key);
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
            elevation: 4.0,
            color: Color(0xFFFFFFFF), // Set card color to light blue
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
                trailing: Icon(
                  item['like'] ? Icons.star : null,
                  color: item['like'] ? Colors.amber : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
