import 'package:flutter/material.dart';
import 'dart:async';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int remainingMinutes = 20; // Thời gian còn lại tính bằng phút
  int remainingSeconds = 0; // Thời gian còn lại tính bằng giây
  Timer? timer; // Biến dùng để đếm ngược

  double audioProgress = 0.0; // Giá trị tiến trình audio
  bool isPlaying = false; // Trạng thái phát audio

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  // Hàm bắt đầu đếm ngược
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--; // Giảm thời gian còn lại mỗi giây
          audioProgress = 1 - ((remainingMinutes * 60 + remainingSeconds) / 1200); // Tính giá trị tiến trình
        } else if (remainingMinutes > 0) {
          remainingMinutes--; // Giảm thời gian còn lại mỗi phút
          remainingSeconds = 59; // Đặt lại giây về 59
          audioProgress = 1 - ((remainingMinutes * 60 + remainingSeconds) / 1200); // Tính giá trị tiến trình
        } else {
          timer.cancel(); // Hủy đếm ngược khi hết thời gian
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // Hủy bỏ timer khi widget bị xóa
    super.dispose();
  }

  // Hàm xử lý bật/tắt audio
  void toggleAudio() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  // Hàm tua audio
  Future<void> seekAudio(double value) async {
    int totalSeconds = 1200;
    int elapsedSeconds = (totalSeconds * value).round();
    setState(() {
      remainingMinutes = (totalSeconds - elapsedSeconds) ~/ 60;
      remainingSeconds = (totalSeconds - elapsedSeconds) % 60;
      audioProgress = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    String remainingTime =
        '${remainingMinutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}'; // Định dạng thời gian

    return Scaffold(
      appBar: AppBar(
        title: Text('Listening Testing'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.grey[200], // Màu nền cho header
            child: Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 48.0,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      remainingTime,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Xử lý sự kiện khi nút được nhấn
                    print('Submit button pressed');
                  },
                  icon: Icon(
                    Icons.navigate_next, // Icon máy bay
                    size: 24, // Kích thước của icon
                    color: Colors.white, // Màu của icon
                  ),
                  label: Text("Submit"),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(15.0)
            ),
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.replay_5),
                  iconSize: 30.0,
                  onPressed: () => seekAudio((audioProgress - 5 / 1200).clamp(0, 1)), // Tua lại 5 giây
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 30.0,
                  onPressed: toggleAudio,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.green,

                  ),


                ),
                IconButton(
                  icon: Icon(Icons.forward_5),
                  iconSize: 30.0,
                  onPressed: () => seekAudio((audioProgress + 5 / 1200).clamp(0, 1)), // Tua tới 5 giây
                ),
                Expanded(
                  child: Slider(
                    value: audioProgress,
                    min: 0,
                    max: 1,
                    onChanged: (value) {
                      seekAudio(value);
                    },
                  ),
                ),
                Icon(Icons.volume_up),
                Container(
                  width: 100,
                  child:  Slider(
                    value: audioProgress,
                    min: 0,
                    max: 1,
                    onChanged: (value) {

                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
