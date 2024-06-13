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
  bool isPlaying = true;

  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double volume = 1.0;
  late String audioPath;
  bool isSliding = false;
  double sliderValue = 0.0;
  Map<String, dynamic> parts = {};
  int currentQuestionIndex = 0;
  int currentPartIndex = 0;
  List<String> partKeys = [];

  @override
  void initState() {
    super.initState();
    remainingMinutes = widget.testSetup.selectedTime;
    initPlayer();
    loadAudioPath();
    startTimer();
    loadQuestions();
  }

  Future<void> loadAudioPath() async {
    try {
      String jsonString =
      await rootBundle.loadString('lib/assets/data/listening.json');
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      Map<String, dynamic> test = jsonMap['listening'][widget.testname];
      Map<String, dynamic> part = test['part'][widget.testSetup.selectedPart];
      setState(() {
        audioPath = part['audio'];
      });

      if (widget.testSetup.isPlaying) {
        playAudio();
      }
    } catch (e) {
      print("Error loading audio path: $e");
    }
  }

  void initPlayer() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
      });
    });

    audioPlayer.onPositionChanged.listen((Duration p) {
      if (!isSliding) {
        setState(() {
          position = p;
          sliderValue = position.inSeconds.toDouble();
        });
      }
    });

    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        position = Duration.zero;
        sliderValue = 0.0;
      });
    });
  }

  Future<void> playAudio() async {
    try {
      int result = audioPlayer.play(UrlSource(audioPath)) as int;
      if (result == 1) {
        print("Audio is playing");
      }
    } catch (e) {
      print("Error in playAudio: $e");
    }
  }

  Future<void> pauseAudio() async {
    try {
      await audioPlayer.pause();
      print("Audio paused");
    } catch (e) {
      print("Error in pauseAudio: $e");
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
          audioProgress =
              1 - ((remainingMinutes * 60 + remainingSeconds) / 1200);
        } else if (remainingMinutes > 0) {
          remainingMinutes--;
          remainingSeconds = 59;
          audioProgress =
              1 - ((remainingMinutes * 60 + remainingSeconds) / 1200);
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

  void loadQuestions() async {
    try {
      String jsonString =
      await rootBundle.loadString('lib/assets/data/listening.json');
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      Map<String, dynamic> test = jsonMap['listening'][widget.testname];
      Map<String, dynamic> partsData = test['part'];
      setState(() {
        parts = partsData;
        partKeys = partsData.keys.toList();
      });
    } catch (e) {
      print("Error loading questions: $e");
    }
  }

  void goToPart(int index) {
    setState(() {
      currentPartIndex = index;
      currentQuestionIndex = 0;
    });
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
        audioPlayer.resume();
      } else {
        pauseAudio();
      }
    });
  }

  Future<void> seekAudio(double value) async {
    setState(() {
      isSliding = true;
    });
    Duration newPosition = Duration(seconds: value.toInt());

    try {
      await audioPlayer.seek(newPosition);
      setState(() {
        position = newPosition;
        sliderValue = position.inSeconds.toDouble();
        isSliding = false;
      });
    } catch (e) {
      print("Error in seekAudio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String remainingTime =
        '${remainingMinutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    List<String> currentPartQuestionsKeys = parts.isNotEmpty
        ? (parts[partKeys[currentPartIndex]]['question'] as Map<String, dynamic>)
        .keys
        .toList()
        : [];
    var questionSet = parts[partKeys[currentPartIndex]]['question']
    as Map<String, dynamic>;

    List<Map<String, String>> questions = [];
    questionSet.forEach((key, value) {
      questions.add({'Q': value['Q'], 'A': value['A']});
    });

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
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff3898D7)),
              ),
              SizedBox(width: 20.0),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
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
                  onPressed: () {
                    seekAudio((sliderValue - 5)
                        .clamp(0, duration.inSeconds.toDouble()));
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
                    seekAudio((sliderValue + 5)
                        .clamp(0, duration.inSeconds.toDouble()));
                  },
                ),
                Expanded(
                  child: Slider(
                    min: 0.0,
                    max: duration.inSeconds.toDouble(),
                    value: sliderValue,
                    onChanged: (value) {
                      setState(() {
                        sliderValue = value;
                      });
                    },
                    onChangeStart: (value) {
                      setState(() {
                        isSliding = true;
                      });
                    },
                    onChangeEnd: (value) {
                      setState(() {
                        isSliding = false;
                      });
                      seekAudio(value);
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
            child: Text(widget.testname,style: TextStyle(
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.w500,

            ),
            ),
            width: 1000,
            decoration: BoxDecoration(
              border:  Border(
                bottom: BorderSide(width: 1.0, color: Colors.black),
              ),
              color: Colors.white,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${index+1}: "+ questions[index]['Q']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter your answer...',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  questions[index]['A'] = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                    ],
                  ),

                );
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.10,
            color: Colors.blue[100],
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: currentPartQuestionsKeys.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentQuestionIndex = index;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentQuestionIndex == index
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
