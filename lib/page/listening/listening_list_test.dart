import 'package:flutter/material.dart';
import 'listening_test_detail.dart';

class ListeningListTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listening Test'),
        backgroundColor: Colors.green,
      ),
      body:
      Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: const BoxDecoration(
            color: Color(0xFFEFF0F6),
            borderRadius: BorderRadius.all(Radius.circular(30))

        ),
          child: BorderRadiusListView(),


      ),
    );
  }
}

class BorderRadiusListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Text(
            'Stay focused, practice regularly and develop note-taking skills to excel in the IELTS listening test',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 8.0),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter test name',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: PopupMenuButton(
                onSelected: (String value) {},
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'like',
                    child: Row(
                      children: [
                        Icon(Icons.thumb_up),
                        SizedBox(width: 8),
                        Text('Like'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share),
                        SizedBox(width: 8),
                        Text('Share'),
                      ],
                    ),
                  ),
                ],
                icon: Icon(Icons.arrow_drop_down),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 4,
          itemBuilder: (context, index) {
            int displayIndex = index + 1;
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                leading: Container(
                  child: const Icon(
                    Icons.headphones,
                    color: Color(0xff1DB954),
                    size: 40.0,
                  ),
                  padding: const EdgeInsets.all(5),
                  width: 50,
                  height: 250,
                  decoration: const BoxDecoration(
                      color: Color(0xffD1F1DC),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
                title: Container(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'GT Listening 0$displayIndex',
                        style: const TextStyle(
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                       LinearProgressIndicator(
                        value: 0.8, // Giá trị thanh tiến trình, bạn có thể thay đổi
                        backgroundColor: Color(0xffD1F1DC),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                      Text(
                        'Score: 8/10', // Điểm số, bạn có thể thay đổi
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailPage()),
                    );
                  },
                  child: Text('Do it now',
                  style: TextStyle(
                    color: Colors.orange,

                  ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFDF1DC)
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}


