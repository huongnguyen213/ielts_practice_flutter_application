import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:audioplayers/audioplayers.dart';
import 'package:ielts_practice_flutter_application/page/listening/test_set_up.dart';




class FullPartPage extends StatefulWidget {
  TestSetup testSetup;


  FullPartPage(this.testSetup);

  @override
  _FullPartPageState createState() => _FullPartPageState();
}

class _FullPartPageState extends State<FullPartPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Map<String, dynamic>> partAnswers;
  late int remainingMinutes;
  int remainingSeconds = 0;
  late Timer timer;
  // Các biến khác ...

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    partAnswers = List.generate(4, (index) => {});
    remainingMinutes = widget.testSetup.selectedTime;
    startTimer();
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
          // Hiển thị hộp thoại khi hết thời gian
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
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String remainingTime =
        '${remainingMinutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
                  backgroundColor: Color(0xff3898D7),
                ),
                onPressed: () {
                  // Xử lý nút submit ở đây
                },
                child: Text('Submit'),
              ),
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Part 1'),
              Tab(text: 'Part 2'),
              Tab(text: 'Part 3'),
              Tab(text: 'Part 4'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            PartContent(partNumber: 1, questionCount: 10, partAnswers: partAnswers[0]),
            PartContent(partNumber: 2, questionCount: 6, partAnswers: partAnswers[1]),
            PartContent(partNumber: 3, questionCount: 9, partAnswers: partAnswers[2]),
            PartContent(partNumber: 4, questionCount: 9, partAnswers: partAnswers[3]),
          ],
        ),
      ),
    );
  }
}
class PartContent extends StatefulWidget {
  final int partNumber;
  final int questionCount;
  final Map<String, dynamic> partAnswers;

  const PartContent({required this.partNumber, required this.questionCount,required this.partAnswers});

  @override
  _PartContentState createState() => _PartContentState();
}

class _PartContentState extends State<PartContent> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = true;
  Duration audioDuration = Duration.zero;
  Duration audioPosition = Duration.zero;
  double sliderValue = 0.0;
  double volume = 0.5;
  String audioUrl = '';
  Map<String, dynamic>? partData;
  late Map<String, dynamic> _selectedValue;
  ScrollController _scrollController = ScrollController();
  late Map<String, TextEditingController> _textControllers;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _textControllers = {};
    _selectedValue = Map.from(widget.partAnswers);
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        audioDuration = duration;
      });
    });
    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        audioPosition = position;
        sliderValue = position.inSeconds.toDouble();
      });
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        audioPosition = Duration.zero;
        sliderValue = 0.0;
      });
    });
    _audioPlayer.setVolume(volume);
    _loadPartData();
  }

  @override
  void dispose() {
    widget.partAnswers.clear();
    _audioPlayer.dispose();
    _scrollController.dispose(); // Dispose ScrollController
    super.dispose();
  }
  void saveAnswer(String questionKey, dynamic answer) {
    setState(() {
      widget.partAnswers[questionKey] = answer;
      _selectedValue[questionKey] = answer;// Lưu câu trả lời vào biến partAnswers
    });
  }


  Future<void> _loadPartData() async {
    try {
      String jsonString = await rootBundle.loadString('lib/assets/data/listening.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);
      setState(() {
        partData = jsonData['listening']['Test 1']['part']['Full Part'];
        audioUrl = partData!['audio']['part${widget.partNumber}']; // Lấy audio cho phần hiện tại
      });
      await playAudio();
    } catch (e) {
      print('Error loading part data: $e');
    }
  }

  Future<void> playAudio() async {
    if (audioUrl.isNotEmpty) {
      int result =  _audioPlayer.play(UrlSource(audioUrl)) as int; // Phải await ở đây
      if (result == 1) {
        setState(() {
          isPlaying = true;
        });
      }
    } else {
      print('Audio URL is empty, cannot play audio.');
    }
  }

  void toggleAudio() {
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(UrlSource(audioUrl));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  Future<void> seekAudio(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void scrollToQuestion(int questionIndex) {
    final position = questionIndex * 200.0; // Adjust this value according to your item height
    _scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return partData == null
        ? Center(child: CircularProgressIndicator())
        : Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController, // Assign ScrollController here
          child: Column(
            children: [
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
                      color: Color(0xff1BAABBF),
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
                                    _audioPlayer.setVolume(volume);
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
              SizedBox(height: 20),
              // Hiển thị các câu hỏi
              if (partData!['question'] != null) ...[
                if (widget.partNumber == 1 || widget.partNumber == 3 || widget.partNumber == 4)
                // Nếu là phần 1, hiển thị các câu hỏi dưới dạng TextField
                  Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: partData!['question'].entries.map<Widget>((entry) {
                        if (entry.value['partk'] == 'Part ${widget.partNumber}') {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.value['Q'] ?? '',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Your answer',
                                ),
                                onChanged: (value) {
                                  saveAnswer(entry.key, value);
                                  // Lưu giá trị vào _selectedValue khi người dùng nhập câu trả lời
                                  _selectedValue[entry.key] = value;
                                },
                                controller: TextEditingController(text: widget.partAnswers[entry.key] ?? ''),
                              ),
                              SizedBox(height: 16),
                            ],
                          );
                        } else {
                          return Container(); // Không hiển thị câu hỏi không phù hợp với part
                        }
                      }).toList(),
                    ),
                  ),
              ],
              if (widget.partNumber == 2)
              // Nếu là phần 2, hiển thị các câu trả
                Container(
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: partData!['question'].entries.map<Widget>((entry) {
                      if (entry.value['partk'] == 'Part ${widget.partNumber}') {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.value['Q'] ?? '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            if (entry.value['AN'] != null && entry.value['AN'] is Map<String, dynamic>)
                              ...((entry.value['AN'] as Map<String, dynamic>).entries.map<Widget>((answerEntry) {
                                return RadioListTile(
                                  title: Text(answerEntry.value.toString()),
                                  value: answerEntry.key,
                                  groupValue:  widget.partAnswers[entry.key],
                                  onChanged: (value) {
                                    setState(() {
                                      saveAnswer(entry.key, value);
                                      _selectedValue[entry.key] = value;
                                    });
                                  },

                                );
                              }).toList()),
                            SizedBox(height: 16),
                          ],
                        );
                      } else {
                        return Container(); // Không hiển thị câu hỏi không phù hợp với part
                      }
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(widget.questionCount, (index) {
                  return ElevatedButton(
                    onPressed: () {
                      scrollToQuestion(index);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue, shape: CircleBorder(),
                      padding: EdgeInsets.all(20), // foreground
                    ),
                    child: Text((index + 1).toString()),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


