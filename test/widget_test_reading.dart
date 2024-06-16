import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ielts_practice_flutter_application/page/reading/cubit/test_cubit.dart';
import 'package:ielts_practice_flutter_application/page/reading/pages/reading_choose_condition_page.dart';
import 'package:ielts_practice_flutter_application/page/reading/pages/reading_page.dart';
import 'package:ielts_practice_flutter_application/page/reading/pages/test_page.dart';
import 'package:ielts_practice_flutter_application/page/reading/widgets/drawable_answers.dart';

void main(){
  // Kiểm tra xây dựng trang TestPage thành công:
  testWidgets('TestPage builds correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TestPage()));
    expect(find.byType(TestPage), findsOneWidget);
  });

  // Kiểm tra sự tương tác khi nhấn nút back:
  testWidgets('Pressing back button pops Navigator', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TestPage()));
    await tester.tap(find.byType(CupertinoButton));
    await tester.pump(); // Rebuild after the button tap
    expect(find.byType(TestPage), findsNothing); // Ensure TestPage is removed from navigation stack
  });

  // Kiểm tra sự hiển thị của CountDownTime widget:
  testWidgets('CountDownTime widget displays correct time', (WidgetTester tester) async {
    final testCubit = TestCubit();
    // Convert Duration to total number of seconds
    final int timeInSeconds = Duration(minutes: 10).inSeconds;
    testCubit.emit(TestState(time: timeInSeconds, parts: [], choosePart: [])); // Set a specific time
    await tester.pumpWidget(MaterialApp(home: BlocProvider.value(value: testCubit, child: TestPage())));
    expect(find.text('10:00'), findsOneWidget); // Adjust as per your CountDownTime widget output format
  });

  // Kiểm tra mở Drawer khi nhấn nút option:
  testWidgets('Pressing option button opens EndDrawer', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TestPage()));
    await tester.tap(find.byType(CupertinoButton).last); // Assuming the last button is the option button
    await tester.pump(); // Rebuild after the button tap
    expect(find.byType(DrawableAnswers), findsOneWidget); // Ensure the EndDrawer is opened
  });

  // Kiểm tra xây dựng trang ReadingChooseConditionPage thành công
  testWidgets('ReadingChooseConditionPage builds correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ReadingChooseConditionPage()));
    expect(find.byType(ReadingChooseConditionPage), findsOneWidget);
  });

  // Kiểm tra sự thay đổi thời gian khi chọn từ dropdown:
  testWidgets('Select time from dropdown', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ReadingChooseConditionPage()));

    await tester.tap(find.byType(DropdownButtonFormField));
    await tester.pump();

    await tester.tap(find.text('20')); // Example selection from dropdown options
    await tester.pump();

    expect(find.text('20'), findsOneWidget); // Adjust based on your dropdown and selected value representation
  });

  // Kiểm tra hành động chuyển đến TestPage khi nhấn nút "Start":
  testWidgets('Press start button and navigate to TestPage', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ReadingChooseConditionPage()));

    // Simulate selecting Part 1 and Part 2, and choosing time 20
    await tester.tap(find.text('Part 1'));
    await tester.tap(find.text('Part 2'));
    await tester.tap(find.byType(DropdownButtonFormField));
    await tester.pump();
    await tester.tap(find.text('20')); // Example selection from dropdown options
    await tester.pump();

    await tester.tap(find.byType(CupertinoButton).last); // Press the Start button
    await tester.pumpAndSettle();

    expect(find.byType(TestPage), findsOneWidget);
  });

  // Kiểm tra tìm kiếm danh sách bài tập theo tên:
  testWidgets('Search for test by name', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ReadingPage()));

    await tester.enterText(find.byType(TextField), '1');
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsNothing);
  });

  

}