import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'test_set_up.dart';

class DetailPage extends StatefulWidget {
  final TestSetup testSetup;
  final String testname;


  DetailPage({required this.testSetup,required this.testname});

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

  @override
  void initState() {
    super.initState();
    remainingMinutes = widget.testSetup.selectedTime;
    initPlayer();
    startTimer();

    if (widget.testSetup.isPlaying) {
      playAudio();
    }
  }
  Future<void> loadAudioPath() async {
    String jsonString = await rootBundle.loadString('lib/assets/data/listening.json');
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    Map<String, dynamic> test = jsonMap['listening']["Listeing "+widget.testname];
    Map<String, dynamic> part = test['part'][widget.testSetup.selectedPart];
    setState(() {
      audioPath = part['audio'];
    });

    if (widget.testSetup.isPlaying) {
      playAudio();
    }
  }



  void initPlayer() {
    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      setState(() {
        position = p;
      });
    });
    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      setState(() {
        isPlaying = s == PlayerState.PLAYING;
      });
    });
  }


  Future<void> playAudio() async {
    await audioPlayer.play(audioPath, isLocal: true);
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
        title: Text('Listening Testing ${widget.testname}'),
        actions: [
          Container(
            margin: EdgeInsets.all(15),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
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
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(15.0),
            ),
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.replay_5),
                  iconSize: 30.0,
                  onPressed: () => seekAudio((audioProgress - 5 / 1200).clamp(0, 1)),
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 30.0,
                  onPressed: toggleAudio,
                ),
                IconButton(
                  icon: Icon(Icons.forward_5),
                  iconSize: 30.0,
                  onPressed: () => seekAudio((audioProgress + 5 / 1200).clamp(0, 1)),
                ),
                Expanded(
                  child: Slider(
                    value: duration.inSeconds.toDouble(),
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await audioPlayer.seek(position);
                      await audioPlayer.resume();
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
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              widget.testSetup.selectedPart,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
