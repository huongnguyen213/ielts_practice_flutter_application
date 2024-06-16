// schedule_reminder.dart

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class ScheduleReminderPage extends StatefulWidget {
  @override
  _ScheduleReminderPageState createState() => _ScheduleReminderPageState();
}

class _ScheduleReminderPageState extends State<ScheduleReminderPage> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BehaviorSubject<String?> _selectedTime = BehaviorSubject<String?>();

  get onDidReceiveNotificationResponse => null;

  @override
  void initState() {
    super.initState();
    tzdata.initializeTimeZones();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializeNotifications();
  }

  @override
  void dispose() {
    _selectedTime.close();
    super.dispose();
  }

  Future<void> initializeNotifications() async {
    var android = AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(android: android);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: onDidReceiveNotificationResponse, // Updated name
    );

  }

  Future<void> selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
      // Handle notification selection here
    }
  }

  Future<void> scheduleNotification(DateTime scheduledNotificationDateTime) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      scheduledNotificationDateTime,
      tz.getLocation(timeZoneName),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Scheduled Notification',
      'It\'s time to study!',
      scheduledDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> showTimePickerDialog(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      DateTime now = DateTime.now();
      DateTime scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      scheduleNotification(scheduledDate);
      _selectedTime.add(pickedTime.format(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Set Reminder Time'),
              subtitle: StreamBuilder<String?>(
                stream: _selectedTime.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!);
                  } else {
                    return const Text('Select time');
                  }
                },
              ),
              trailing: ElevatedButton(
                onPressed: () => showTimePickerDialog(context),
                child: const Text('Pick Time'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
