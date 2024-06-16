import 'package:flutter/material.dart';
import '../../writing/take_picture_part1.dart';

class WritingContentWidget extends StatefulWidget {
  final Map<String, dynamic> part1Data;
  final Map<String, dynamic> part2Data;
  final Duration remainingTime;

  const WritingContentWidget({
    Key? key,
    required this.part1Data,
    required this.part2Data,
    required this.remainingTime,
  }) : super(key: key);

  @override
  _WritingContentWidgetState createState() => _WritingContentWidgetState();
}

class _WritingContentWidgetState extends State<WritingContentWidget> {
  bool isPart1 = true;

  void _captureImageFromCamera(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TakePictureScreen(remainingTime: widget.remainingTime)),
    ).then((imagePath) {
      if (imagePath != null) {
        setState(() {
          if (isPart1) {
            widget.part1Data['img'] = imagePath;
          } else {
            widget.part2Data['img'] = imagePath;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final partData = isPart1 ? widget.part1Data : widget.part2Data;

    return Column(
      children: [
        Container(
          color: Color(0xFFB5E0EA),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    isPart1 = true;
                  });
                },
                child: Text(
                  'Part 1',
                  style: TextStyle(color: isPart1 ? Colors.white : Colors.black),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isPart1 = false;
                  });
                },
                child: Text(
                  'Part 2',
                  style: TextStyle(color: isPart1 ? Colors.black : Colors.white),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final halfHeight = constraints.maxHeight / 2;
              return Column(
                children: [
                  Container(
                    height: halfHeight,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (isPart1 ? 'Part 1: ' : 'Part 2: ') + partData['note'],
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(height: 10),
                            Text(partData[isPart1 ? 'q1' : 'q2'] ?? ''), // Dynamic selection of q1 or q2
                            SizedBox(height: 10),
                            if (isPart1 && partData['img'] is String) // Check if img is a String
                              Image.asset(partData['img']),
                          ],
                        ),
                      ),
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
                        _captureImageFromCamera(context);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
