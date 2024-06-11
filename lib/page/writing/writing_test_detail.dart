import 'package:flutter/material.dart';

class WritingDetailPage extends StatelessWidget {
  final dynamic writingData;

  const WritingDetailPage({Key? key, required this.writingData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tạo giao diện của trang bài viết chi tiết ở đây
    return Scaffold(
      appBar: AppBar(
        title: Text('Writing Detail'),
      ),
      body: Center(
        child: Text('Detail of ${writingData['name']}'),
      ),
    );
  }
}
