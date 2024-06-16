import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ielts_practice_flutter_application/page/layout/profile.dart';
import 'package:ielts_practice_flutter_application/page/layout/progress.dart';
import 'package:ielts_practice_flutter_application/page/listening/listening_list_test.dart';
import 'package:ielts_practice_flutter_application/page/reading/reading_list_test.dart';
import 'package:ielts_practice_flutter_application/page/writing/writing_list_test.dart';
import 'package:ielts_practice_flutter_application/page/speaking/speaking_list_test.dart';

import '../full_skill/list_test.dart';
import '../reading/pages/reading_page.dart';


class HomePage extends StatefulWidget {
  @override
  _IELTSHomeState createState() => _IELTSHomeState();
}

class _IELTSHomeState extends State<HomePage> with SingleTickerProviderStateMixin{
  bool isAcademic = true;
  int _currentCarouselIndex = 0;
  int _selectedIndex = 0;
  late TabController _tabController;
  final List<Color> _tabColors = [Colors.grey, Colors.blue];

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

  List<String> carouselTexts = [
    '"Start with a clear purpose in mind, keep your sentences concise, and revise for clarity."',
    '"Master IELTS Academic: Open Doors to Global Success!"',
    '"Language is “the infinite use of finite means. – Wilhelm von Humboldt"',
  ];

  List<Widget> carouselSlides = [];

  @override
  void initState() {
    super.initState();
    // Initialize carouselSlides from the initial list
    _updateCarouselSlides();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _updateCarouselSlides() {
    carouselSlides = carouselTexts.map((text) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            padding: const EdgeInsets.all(16),
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        },
      );
    }).toList();
  }

  @override
  void dispose(){
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _tabColors[_selectedIndex] = const Color(0xFFB5E0EA);
      for (int i = 0; i < _tabColors.length; i++){
        if (i != _selectedIndex){
          _tabColors[i] = Colors.grey;
        }
      }
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }else if (index == 1){
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProgressPage())
      );
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'IELTS',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.amber),
            onPressed: () {},
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                const SizedBox(width: 8),
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                const SizedBox(width: 8),
                                Text('General', style: TextStyle(color: !isAcademic ? Colors.blue : Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      child: CarouselSlider(
                        items: carouselSlides,
                        options: CarouselOptions(
                          height: 120.0,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                          enableInfiniteScroll: true,
                          viewportFraction: 1.0,
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
                  children: isAcademic ? [
                    _buildGridItem('Listening Test', ListeningListTestPage()),
                    _buildGridItem('Reading Test', ReadingListTestPage()),
                    _buildGridItem('Writing Test', WritingListTestPage()),
                    _buildGridItem('Speaking Test', SpeakingListTestPage()),
                    _buildGridItem('Full Skills', null),
                    _buildGridItem('Grammar', null),
                  ] : [
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
          ProgressPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: const [
        Tab(icon: Icon(Icons.home), text: "Home"),
        Tab(icon: Icon(Icons.bar_chart), text: "Progress"),
        Tab(icon: Icon(Icons.person_2_rounded), text: "Personal"),
      ],
      labelColor: const Color(0xFF6EC3D2),
      unselectedLabelColor: Colors.grey,
    ),
    );
  }

  Widget _buildGridItem(String label, Widget? page) {
    return Card(
        margin: const EdgeInsets.all(8),
    elevation: 4,
    shadowColor: Colors.black54,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
    ),
    child: InkWell(
    onTap:
        () {
          if(label=="Reading Test"||label=="Reading Practice"){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ReadingPage()));
          }
          else if (page != null) {
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
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

}