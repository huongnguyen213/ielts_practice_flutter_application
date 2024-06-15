import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:audioplayers/audioplayers.dart';

class Part3Page extends StatefulWidget {
  @override
  _Part3PageState createState() => _Part3PageState();
}

class _Part3PageState extends State<Part3Page> {
  late int remainingMinutes;
  int remainingSeconds = 0;
  late Timer timer;
  double sliderValue = 0.0;
  List<bool> questionAnswered = [];
  late Map<String, dynamic> questions;
  bool isLoading = true;
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  late List<String> userAnswers;
  Duration audioDuration = Duration.zero;
  Duration audioPosition = Duration.zero;
  double volume = 1.0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    remainingMinutes = 6; // Thời gian mặc định là 6 phút
    startTimer();
    userAnswers = List.filled(10, '');
    loadJsonData();
    audioPlayer = AudioPlayer();
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        audioDuration = duration;
      });
    });
    audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        audioPosition = position;
        sliderValue = audioPosition.inSeconds.toDouble();
      });
    });
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing) {
        setState(() {
          isPlaying = true;
        });
      } else {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  Future<void> loadJsonData() async {
    try {
      final String response =
      await rootBundle.loadString('lib/assets/data/listening.json');
      final data = json.decode(response);
      final test1Part1Questions =
      data['listening']['Test 1']['part']['Part 3']['question'];
      final audioUrl = data['listening']['Test 1']['part']['Part 3']['audio'];
      final answers =
      test1Part1Questions.values.map((question) => question['A'] as String).toList();
      setState(() {
        questions = Map<String, dynamic>.from(test1Part1Questions);
        questionAnswered = List.generate(questions.length, (index) => false);
        isLoading = false;
      });
      playAudio(audioUrl);
    } catch (e) {
      print("Error loading JSON data: $e");
    }
  }

  void playAudio(String url) async {
    try {
      int result = audioPlayer.play(UrlSource(url)) as int;
      if (result == 1) {
        setState(() {
          isPlaying = true;
        });
      }
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void pauseAudio() async {
    try {
      int result = audioPlayer.pause() as int;
      if (result == 1) {
        setState(() {
          isPlaying = false;
        });
      }
    } catch (e) {
      print("Error pausing audio: $e");
    }
  }

  void seekAudio(Duration position) {
    audioPlayer.seek(position);
  }

  void changeVolume(double newVolume) {
    audioPlayer.setVolume(newVolume);
    setState(() {
      volume = newVolume;
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else if (remainingMinutes > 0) {
          remainingMinutes--;
          remainingSeconds = 59;
        } else {
          timer.cancel();
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
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  void toggleAudio() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        audioPlayer.resume();
      } else {
        pauseAudio();
      }
    });
  }

  void _scrollToQuestion(int index) {
    // Cuộn đến vị trí của câu hỏi
    _scrollController.animateTo(
      index * 100.0, // Ví dụ: 100.0 là chiều cao của mỗi item (câu hỏi và textfield)
      duration: Duration(milliseconds: 500), // Thời gian cuộn
      curve: Curves.easeInOut, // Kiểu animation
    );
  }

  void _showSubmitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submit Answers'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(questions.length, (index) {
              final questionKey = 'q${index + 1}';
              final question = questions[questionKey]!['Q']!;
              final answer = userAnswers[index].isEmpty ? 'Not Done' : userAnswers[index];
              return Text('$question: $answer');
            }),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Đặt logic xử lý khi người dùng ấn Submit ở đây
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String remainingTime =
        '${remainingMinutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffE2F1F4),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage('icons/oclock.png'),
                  size: 48,
                ),
                SizedBox(width: 5),
                Text(
                  remainingTime,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff3898D7)),
              onPressed: () {
                _showSubmitDialog();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 10),
          Container(
            height: MediaQuery.of(context).size.height * 0.10,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.black),
              ),
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
                  onPressed: () {
                    seekAudio(Duration(seconds: audioPosition.inSeconds - 5));
                  },
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
                  onPressed: () {
                    seekAudio(Duration(seconds: audioPosition.inSeconds + 5));
                  },
                ),
                Expanded(
                  child: Slider(
                    min: 0.0,
                    max: audioDuration.inSeconds.toDouble(),
                    value: sliderValue,
                    onChanged: (value) {
                      setState(() {
                        sliderValue = value;
                        seekAudio(Duration(seconds: sliderValue.toInt()));
                      });
                    },
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.volume_up,
                    color: Color(0xff1BAABF),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Volume"),
                          content: Slider(
                            value: volume,
                            min: 0.0,
                            max: 1.0,
                            divisions: 10,
                            onChanged: (value) {
                              setState(() {
                                volume = value;
                                audioPlayer.setVolume(volume);
                              });
                            },
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(height: 30),
                Text(
                  "Part 3",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            width: 1000,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.black),
              ),
              color: Colors.white,
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(),
            child: Text(
              "Write NO MORE THAN THREE WORDS OR A NUMBER for each answer.",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              controller: _scrollController,
              itemCount: questions.length,
              itemBuilder: (context, index) {
                String questionKey = questions.keys.elementAt(index);
                String questionText = questions[questionKey]['Q'];
                return Container(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}: $questionText',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8), // Khoảng cách giữa câu hỏi và TextField
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter your answer here',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0), // Đặt bán kính của border radius ở đây
                          ),
                          focusedBorder: OutlineInputBorder( // Đường viền khi TextField được focus
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.blue, // Màu sắc của đường viền khi TextField được focus
                              width: 2.0, // Độ dày của đường viền khi TextField được focus
                            ),
                          ),
                          enabledBorder: OutlineInputBorder( // Đường viền khi TextField không được focus
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.grey, // Màu sắc của đường viền khi TextField không được focus
                              width: 1.0, // Độ dày của đường viền khi TextField không được focus
                            ),
                          ),
                        ),
                        onChanged: (text) {
                          setState(() {
                            questionAnswered[index] = text.isNotEmpty;
                            userAnswers[index] = text;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                children: List.generate(questions.length, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _scrollToQuestion(index);
                        // Xử lý di chuyển đến câu hỏi tương ứng
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: questionAnswered[index] ? Colors.green : Color(0xffD3D3D3),
                        padding: EdgeInsets.all(4.0),
                        shape: CircleBorder(),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

