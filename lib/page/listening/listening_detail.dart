import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'test_set_up.dart';

class DetailPage extends StatefulWidget {
  final TestSetup testSetup;
  final String testname;

  DetailPage({required this.testSetup, required this.testname});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late int remainingMinutes;
  int remainingSeconds = 0;
  Timer? timer;

  double audioProgress = 0.0;
  bool isPlaying = false;

  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration();
  Duration position = Duration();
  double volume = 1.0;
  late String audioPath;
  bool isSliding = false;
  double sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    remainingMinutes = widget.testSetup.selectedTime;
    initPlayer();
    loadAudioPath();
    startTimer();
  }

  Future<void> loadAudioPath() async {
    String jsonString = await rootBundle.loadString('lib/assets/data/listening.json');
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    Map<String, dynamic> test = jsonMap['listening'][widget.testname];
    Map<String, dynamic> part = test['part'][widget.testSetup.selectedPart];
    print(part);
    setState(() {
      audioPath = part['audio'];

    });

    if (widget.testSetup.isPlaying) {
      playAudio();
      print(audioPath);
    }
  }

  void initPlayer() {
    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
        // Cập nhật Slider khi có thay đổi thời lượng audio
        sliderValue = position.inSeconds.toDouble();
      });
    });
    audioPlayer.onDurationChanged.listen((Duration p) {
      setState(() {
        if (!isSliding) {
          position = p;
          // Cập nhật Slider khi có thay đổi vị trí audio
          sliderValue = position.inSeconds.toDouble();
        }
      });
    });
    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      setState(() {
        isPlaying = s == PlayerState.playing;
      });
    });
  }

  Future<void> playAudio() async {
    Source source=UrlSource(audioPath);
    await audioPlayer.play(source);
  }

  Future<void> pauseAudio() async {
    await audioPlayer.pause();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
          audioProgress = 1 - ((remainingMinutes * 60 + remainingSeconds) / 1200);
        } else if (remainingMinutes > 0) {
          remainingMinutes--;
          remainingSeconds = 59;
          audioProgress = 1 - ((remainingMinutes * 60 + remainingSeconds) / 1200);
        } else {
          timer.cancel();
          showAlertDialog();
        }
      });
    });
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Time is up!'),
          content: Text('The timer has ended.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    audioPlayer.dispose();
    audioPlayer.release();
    super.dispose();
  }

  void toggleAudio() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        playAudio();
      } else {
        pauseAudio();
      }
    });
  }

  Future<void> seekAudio(double value) async {
    final newPosition = Duration(seconds: value.toInt());
    await audioPlayer.seek(newPosition);
    if (!isPlaying) {
      await audioPlayer.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    String remainingTime =
        '${remainingMinutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffB5E0EA),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageIcon(
                AssetImage('icons/oclock.png'),
                size: 48,
              ),
              SizedBox(width: 10.0),
              Text(
                remainingTime,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 90.0),
              ElevatedButton(
                onPressed: () {
                  // Submit button functionality
                },
                child: Text('Submit',style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff3898D7)
                ),
              ),
              SizedBox(width: 20.0),
            ],
          ),

        ],
      ),
      backgroundColor: Colors.white,
      body:

      Column(
        children: [
          // Frame 1 - 22
          // Frame 2 - 60%
          Expanded(
            child: Column(
              children: [
                // Subframe 1 - 10% (Audio Controls)
                Container(
                  height: MediaQuery.of(context).size.height * 0.10,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),

                  ),
                  padding: EdgeInsets.all(5.0),
                  margin: EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.replay_5),
                        color: Color(0xff1BAABF),
                        iconSize: 30.0,
                        onPressed: () => seekAudio((audioProgress - 5 / 1200).clamp(0, 1)),
                      ),
                      Container(

                        decoration: BoxDecoration(
                          color: Color(0xff1BAABF),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(15)),

                        ),
                        child: IconButton(

                          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                          iconSize: 30.0,

                          color: Colors.white,


                          onPressed: toggleAudio,
                        ),
                      ),
                      IconButton(
                        color: Color(0xff1BAABF),
                        icon: Icon(Icons.forward_5),
                        iconSize: 30.0,
                        onPressed: () => seekAudio((audioProgress + 5 / 1200).clamp(0, 1)),
                      ),
                      Expanded(
                        child:Slider(
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          value: isPlaying
                              ? position.inSeconds.toDouble().clamp(0,
                              duration.inSeconds.toDouble())
                              : sliderValue,// Sử dụng clamp để giữ giá trị trong khoảng cho phép
                          onChanged: (value) {
                            setState(() {
                              isSliding = true; // Đánh dấu rằng Slider đang được trượt
                              final seconds = value.toInt().clamp(0, duration.inSeconds); // Đảm bảo giá trị không vượt quá thời lượng
                              position = Duration(seconds: seconds);
                            });
                          },
                          onChangeEnd: (value) {
                            final newPosition = value * 1.0;
                            seekAudio(newPosition);
                            setState(() {
                              isSliding = false; // Đánh dấu rằng Slider không được trượt nữa
                            });
                          },
                        ),




                      ),
                      Icon(Icons.volume_up),
                      Container(
                        width: 100,
                        child: Slider(
                          value: volume,
                          min: 0,
                          max: 1,
                          onChanged: (value) {
                            setState(() {
                              volume = value;
                              audioPlayer.setVolume(volume);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Subframe 2 - 50% (Questions)
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        // Replace with your questions widgets
                        Container(
                          width: 1000,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(width: 1.0, color: Colors.grey), // Border ở dưới
                            ),


                          ),
                          child: Text(
                            widget.testSetup.selectedPart,
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Frame 3 - 10% (Navigation Buttons)
          Container(
            height: MediaQuery.of(context).size.height * 0.10,
            color: Colors.blue[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Replace with your navigation buttons
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  iconSize: 30.0,
                  onPressed: () {
                    // Previous question
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  iconSize: 30.0,
                  onPressed: () {
                    // Next question
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}