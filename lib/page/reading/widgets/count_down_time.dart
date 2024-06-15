import 'dart:async';

import 'package:flutter/material.dart';
//CountDownTime: widgets đếm ngược thời gian, nhấn số phút cần đếm ngược từ người dùng, cấp nhật và hiển thị time còn lại
class CountDownTime extends StatefulWidget {
  const CountDownTime({super.key, required this.target});

  final int target;

  @override
  State<CountDownTime> createState() => _CountDownTimeState();
}

class _CountDownTimeState extends State<CountDownTime> {
  late DateTime _targetDate; // lưu trữ thời gian đếm ngược
  late Timer _timer;  //tạo bộ đếm thời gian
  Duration _timeUntilTarget = const Duration(); //lưu trữ còn lại

  @override
  void initState() { //gọi khi widger khởi tạo
    _targetDate = DateTime.now().add(Duration(minutes: widget.target));
    _updateTimeUntilTarget();
    _timer = Timer.periodic(
        const Duration(seconds: 1), (_) => _updateTimeUntilTarget());
    super.initState();
  }

  void _updateTimeUntilTarget() {
    setState(() {
      final now = DateTime.now();
      _timeUntilTarget = _targetDate.difference(now);
    });
  }

  @override
  Widget build(BuildContext context) { //tạo giao diện người dùng
    int minutes = _timeUntilTarget.inMinutes.remainder(60);
    int seconds = _timeUntilTarget.inSeconds.remainder(60);

    if (minutes <= 0 && seconds <= 0) { //tính toán số phút và giây còn lại
      return const Text(
        "Out of time",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      );
    } else {
      return Text(
        '$minutes : $seconds',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
