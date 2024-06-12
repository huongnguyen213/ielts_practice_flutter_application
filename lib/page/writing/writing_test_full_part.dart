import 'package:flutter/material.dart';

class WritingTestFullPartPage extends StatefulWidget {
  final String testTitle;
  final Map<String, dynamic> part1Data;
  final Map<String, dynamic> part2Data;
  final String selectedTime;

  WritingTestFullPartPage({
    required this.testTitle,
    required this.part1Data,
    required this.part2Data,
    required this.selectedTime, required String selectedPart, required Map testPartData,
  });

  @override
  _WritingTestFullPartPageState createState() => _WritingTestFullPartPageState();
}

class _WritingTestFullPartPageState extends State<WritingTestFullPartPage> {
  String selectedPart = 'Part 1';

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> selectedPartData = selectedPart == 'Part 1' ? widget.part1Data : widget.part2Data;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer),
            SizedBox(width: 5),
            Text(widget.selectedTime),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              // Add navigation action if needed
            },
          ),
        ],
        backgroundColor: Color(0xFFB5E0EA),
      ),
      body: Column(
        children: [
          Container(
            color: Color(0xFFB5E0EA),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedPart = 'Part 1';
                    });
                  },
                  child: Text('Part 1', style: TextStyle(color: selectedPart == 'Part 1' ? Colors.white : Colors.black)),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedPart = 'Part 2';
                    });
                  },
                  child: Text('Part 2', style: TextStyle(color: selectedPart == 'Part 2' ? Colors.white : Colors.black)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedPartData['note'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(selectedPart == 'Part 1' ? selectedPartData['q1'] : selectedPartData['q2']), // Sửa dòng này
                SizedBox(height: 10),
                if (selectedPart == 'Part 1') // Check if part is 1 to display the image
                  Image.asset(selectedPartData['img']),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'Your answer...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                // Add image capture functionality
                _captureImageFromCamera(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to capture image from camera
  void _captureImageFromCamera(BuildContext context) {
    // Add your code here to capture image from camera
    // For example:
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => CameraScreen()),
    // );
  }
}
