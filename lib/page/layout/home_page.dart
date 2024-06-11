import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
  int _currentCarouselIndex = 0;

  final Map<String, String> iconPaths = {
    'Listening Test': 'icons/icons8-headphone-48.png',
    'Reading Test': 'icons/icons8-book-48.png',
    'Writing Test': 'icons/icons8-pencil-48.png',
    'Speaking Test': 'icons/icons8-mic-48.png',
    'Full Skills': 'icons/icons8-diversity-48.png',
    'Grammar': 'icons/icons8-grammar-48.png',
    'Listening Practice': 'icons/icons8-headphone-48.png',
    'Reading Practice': 'icons/icons8-book-48.png',
    'Writing Practice': 'icons/icons8-pencil-48.png',
    'Speaking Practice': 'icons/icons8-mic-48.png',
    'General Skills': 'icons/icons8-diversity-48.png',
    'Grammar Practice': 'icons/icons8-grammar-48.png',
  };

  final List<String> carouselTexts = [
    '"Start with a clear purpose in mind, keep your sentences concise, and revise for clarity."',
    '"Master IELTS Academic: Open Doors to Global Success!"'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'IELTS',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
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
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isAcademic ? Colors.blue : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                'icons/icons8-mortarboard-48.png', // Academic icon
                                width: 40,
                                height: 40,
                              ),
                              SizedBox(width: 8),
                              Text('Academic', style: TextStyle(color: isAcademic ? Colors.blue : Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isAcademic = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: !isAcademic ? Colors.blue : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                'icons/icons8-people-skin-type-7-48.png', // General icon
                                width: 40,
                                height: 40,
                              ),
                              SizedBox(width: 8),
                              Text('General', style: TextStyle(color: !isAcademic ? Colors.blue : Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child:CarouselSlider(
                      items: carouselTexts.map((text) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width, // Chiều rộng của mỗi item là chiều rộng của màn hình
                              margin: EdgeInsets.symmetric(horizontal: 5.0), // Khoảng cách giữa các item
                              padding: EdgeInsets.all(16),
                              child: Text(
                                text,
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 120.0, // Chiều cao của carousel
                        autoPlay: true, // Tự động chuyển slide
                        autoPlayInterval: Duration(seconds: 2), // Thời gian chờ giữa các chuyển slide
                        autoPlayAnimationDuration: Duration(milliseconds: 800), // Thời gian animation của chuyển slide
                        enableInfiniteScroll: true, // Cho phép cuộn vô hạn
                        viewportFraction: 1.0, // Phần trăm của màn hình mà mỗi item chiếm
                        onPageChanged: (index, _) {
                          setState(() {
                            _currentCarouselIndex = index;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: isAcademic
                    ? [
                  _buildGridItem('Listening Test', ListeningListTestPage()),
                  _buildGridItem('Reading Test', ReadingListTestPage()),
                  _buildGridItem('Writing Test', WritingListTestPage()),
                  _buildGridItem('Speaking Test', SpeakingListTestPage()),
                  _buildGridItem('Full Skills', null),
                  _buildGridItem('Grammar', null),
                ]
                    : [
                  _buildGridItem('Listening Practice', ListeningListTestPage()),
                  _buildGridItem('Reading Practice', ReadingListTestPage()),
                  _buildGridItem('Writing Practice', WritingListTestPage()),
                  _buildGridItem('Speaking Practice', SpeakingListTestPage()),
                  _buildGridItem('General Skills', null),
                  _buildGridItem('Grammar Practice', null),
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
    onTap: (index) {
    setState(() {
    isAcademic = index == 0;
    });
    },
        ),
    );
  }

  Widget _buildGridItem(String label, Widget? page) {
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
              Image.asset(iconPaths[label]!, width: 40, height: 40),
              SizedBox(height: 8),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

