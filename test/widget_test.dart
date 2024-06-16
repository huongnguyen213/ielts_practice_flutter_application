// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ielts_practice_flutter_application/main.dart';
import 'package:ielts_practice_flutter_application/page/layout/home_page.dart';
import 'package:ielts_practice_flutter_application/page/layout/profile.dart';
import 'package:ielts_practice_flutter_application/page/layout/progress.dart';
import 'package:ielts_practice_flutter_application/page/reading/pages/reading_page.dart';
import 'package:ielts_practice_flutter_application/page/speaking/popup_setup.dart';
import 'package:ielts_practice_flutter_application/page/speaking/search_filter_widget.dart';
import 'package:ielts_practice_flutter_application/page/speaking/speaking_instructions.dart';
import 'package:ielts_practice_flutter_application/page/speaking/speaking_question.dart';
import 'package:ielts_practice_flutter_application/page/writing/take_picture_part1.dart';
import 'package:ielts_practice_flutter_application/page/writing/writing_list_test.dart';
import 'package:ielts_practice_flutter_application/page/writing/writing_result.dart';
import 'package:ielts_practice_flutter_application/page/writing/writing_set_up_test.dart';
import 'package:ielts_practice_flutter_application/page/writing/writing_test_part1.dart';
import 'package:path_provider/path_provider.dart';

void main() {

  // unit test

  // 1. home page

  // Kiểm tra khởi tạo ban đầu của widget -- false
  testWidgets('HomePage initializes with Academic mode', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    // Expect that the default mode is Academic
    expect(find.text('Academic'), findsOneWidget);
    expect(find.text('General'), findsNothing);
  });

  // Kiểm tra chuyển đổi giữa chế độ Academic và General -- false
  testWidgets('Switch between Academic and General mode', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    // Tap on General mode
    await tester.tap(find.text('General'));
    await tester.pump();

    // Expect that General mode is active
    expect(find.text('Academic'), findsNothing);
    expect(find.text('General'), findsOneWidget);

    // Tap on Academic mode
    await tester.tap(find.text('Academic'));
    await tester.pump();

    // Expect that Academic mode is active again
    expect(find.text('Academic'), findsOneWidget);
    expect(find.text('General'), findsNothing);
  });

  // Kiểm tra điều hướng khi nhấp vào các mục trong GridView -- false
  testWidgets('Navigate to specific pages when tapping grid items', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    // Tap on Reading Test
    await tester.tap(find.text('Reading Test'));
    await tester.pump();

    // Expect that ReadingPage is pushed
    expect(find.byType(ReadingPage), findsOneWidget);
  });

  // Kiểm tra hành vi của BottomNavigationBar
  testWidgets('Navigate to Home page when tapping on BottomNavigationBar items', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    // Tap on Progress
    await tester.tap(find.text('Progress'));
    await tester.pump();

    // Expect that the Progress page is not pushed immediately
    expect(find.byType(ProgressPage), findsNothing);

    // Tap on Home
    await tester.tap(find.text('Home'));
    await tester.pump();

    // Expect that HomePage is re-rendered
    expect(find.text('Academic'), findsOneWidget);
  });

  // Kiểm tra hành vi của CarouselSlider
  testWidgets('Check if CarouselSlider displays messages', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    // Expect to find the initial carousel message
    expect(find.text('"Start with a clear purpose in mind, keep your sentences concise, and revise for clarity."'), findsOneWidget);

    // Swipe left on the carousel
    await tester.fling(find.byType(CarouselSlider), Offset(-500, 0), 300);
    await tester.pump();

    // Expect to find the next carousel message
    expect(find.text('"Master IELTS Academic: Open Doors to Global Success!"'), findsOneWidget);
  });

  // 2.writing

  // writing list test
  // Kiểm tra tìm kiếm danh sách các bài viết trong writing list test
  testWidgets('Search functionality filters writing items', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WritingListTestPage()));

    // Enter text into search field
    await tester.enterText(find.byType(TextField), 'Writing 1');
    await tester.pump();

    // Expect that only items containing 'Writing 1' in their name are visible
    expect(find.text('Writing 1'), findsOneWidget);
    expect(find.text('Writing 2'), findsNothing);
    expect(find.text('Writing 3'), findsNothing);
  });

  // Kiểm tra chuyển đổi yêu thích của một bài viết trong writing list test
  testWidgets('Toggle favorite for a writing item', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WritingListTestPage()));

    // Tap on the star icon of the first item in the list
    await tester.tap(find.byIcon(Icons.star_border).first);
    await tester.pump();

    // Expect that the star icon changes to filled (favorite)
    expect(find.byIcon(Icons.star), findsOneWidget);

    // Tap again to toggle the favorite state
    await tester.tap(find.byIcon(Icons.star).first);
    await tester.pump();

    // Expect that the star icon changes back to border (not favorite)
    expect(find.byIcon(Icons.star_border), findsOneWidget);
  });

  // Kiểm tra điều hướng khi nhấp vào một mục trong danh sách
  testWidgets('Navigate to setup page when writing item is pressed', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WritingListTestPage()));

    // Tap on the first item in the list
    await tester.tap(find.text('Writing 1'));
    await tester.pump();

    // Expect that the WritingSetUpPage is pushed onto the navigator stack
    expect(find.byType(WritingSetUpPage), findsOneWidget);
  });

  // Kiểm tra chức năng lọc với DropdownButton
  testWidgets('Filter writing items with DropdownButton', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WritingListTestPage()));

    // Open the dropdown
    await tester.tap(find.byType(DropdownButton).first);
    await tester.pump();

    // Tap on the 'Like' option
    await tester.tap(find.text('Like').first);
    await tester.pump();

    // Expect that only favorite items are visible
    expect(find.byType(ListTile), findsNWidgets(0)); // Adjust based on expected behavior
  });

  // set up
  // Kiểm tra khởi tạo và hiển thị ConfettiWidget
  testWidgets('ConfettiWidget initializes and displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WritingTestResult()));

    // Kiểm tra ConfettiWidget có xuất hiện hay không
    expect(find.byType(ConfettiWidget), findsOneWidget);

    // Kiểm tra các thuộc tính của ConfettiWidget
    final confettiWidget = tester.widget<ConfettiWidget>(find.byType(ConfettiWidget));
    expect(confettiWidget.confettiController, isNotNull);
    expect(confettiWidget.blastDirectionality, BlastDirectionality.explosive);
    expect(confettiWidget.maxBlastForce, 30);
    expect(confettiWidget.minBlastForce, 10);
    expect(confettiWidget.emissionFrequency, 0.05);
    expect(confettiWidget.numberOfParticles, 20);
    expect(confettiWidget.gravity, 0.1);
    expect(confettiWidget.shouldLoop, isFalse);
  });

  // Kiểm tra hiển thị các widget con trong trang kết quả
  testWidgets('Displays congratulatory message and image correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WritingTestResult()));

    // Kiểm tra hình ảnh và các text hiển thị đúng
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Congratulations!!!'), findsOneWidget);
    expect(find.text('You have completed the test'), findsOneWidget);
    expect(find.text('We will send your scores to you soon'), findsOneWidget);
  });

  // Kiểm tra thanh điều hướng dưới cùng và điều hướng
  testWidgets('Bottom navigation bar and navigation to home page', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WritingTestResult()));

    // Kiểm tra BottomNavigationBar có xuất hiện không
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Kiểm tra các mục trong BottomNavigationBar
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Nhấn vào mục 'Home' và kiểm tra điều hướng
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    // Kiểm tra xem đã điều hướng tới trang HomePage hay chưa
    expect(find.byType(HomePage), findsOneWidget);
  });

  // Kiểm tra AppBar có hiển thị đúng không
  testWidgets('AppBar displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WritingTestResult()));

    // Kiểm tra AppBar có tiêu đề đúng và không có nút quay lại
    expect(find.text('IELTS'), findsOneWidget);
    expect(find.byIcon(Icons.notifications), findsOneWidget);
    expect(find.byType(BackButton), findsNothing);
  });

  // writing test part 1
  // Kiểm tra khởi tạo bộ đếm thời gian
  testWidgets('Timer initializes and starts correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: WritingTestPart1Page(
        testTitle: 'Sample Test',
        testPartData: {
          'note': 'This is a note',
          'q1': 'Sample question?',
          'img': 'assets/sample_image.png',
        },
        selectedPart: 'Part 1',
        selectedTime: '15 minutes',
      ),
    ));

    // Kiểm tra thời gian ban đầu hiển thị đúng
    expect(find.text('15:00'), findsOneWidget);

    // Chờ 1 giây và kiểm tra thời gian cập nhật
    await tester.pump(Duration(seconds: 1));
    expect(find.text('14:59'), findsOneWidget);
  });

  // Kiểm tra hiển thị thông tin câu hỏi
  testWidgets('Displays question information correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: WritingTestPart1Page(
        testTitle: 'Sample Test',
        testPartData: {
          'note': 'This is a note',
          'q1': 'Sample question?',
          'img': 'assets/sample_image.png',
        },
        selectedPart: 'Part 1',
        selectedTime: '15 minutes',
      ),
    ));

    // Kiểm tra hiển thị note và câu hỏi
    expect(find.text('Part 1: This is a note'), findsOneWidget);
    expect(find.text('Sample question?'), findsOneWidget);

    // Kiểm tra hiển thị hình ảnh
    expect(find.byType(Image), findsOneWidget);
  });

  // Kiểm tra hiển thị hộp thoại khi hết giờ
  testWidgets('Shows time up dialog when timer ends', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: WritingTestPart1Page(
        testTitle: 'Sample Test',
        testPartData: {
          'note': 'This is a note',
          'q1': 'Sample question?',
          'img': 'assets/sample_image.png',
        },
        selectedPart: 'Part 1',
        selectedTime: '1 minute',
      ),
    ));

    // Giả lập việc hết giờ
    await tester.pump(Duration(minutes: 1, seconds: 1));

    // Kiểm tra hộp thoại hiển thị
    expect(find.text('Time is up!'), findsOneWidget);
    expect(find.text('Your time is over. Submitting the test.'), findsOneWidget);
  });

  // Kiểm tra chức năng chụp ảnh
  testWidgets('Capture image from camera', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: WritingTestPart1Page(
        testTitle: 'Sample Test',
        testPartData: {
          'note': 'This is a note',
          'q1': 'Sample question?',
          'img': 'assets/sample_image.png',
        },
        selectedPart: 'Part 1',
        selectedTime: '15 minutes',
      ),
    ));

    // Nhấn vào nút camera
    await tester.tap(find.byIcon(Icons.camera_alt));
    await tester.pumpAndSettle();

    // Kiểm tra điều hướng đến màn hình chụp ảnh
    expect(find.byType(TakePictureScreen), findsOneWidget);
  });

  // Kiểm tra hộp thoại xác nhận nộp bài
  testWidgets('Shows submit confirmation dialog', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: WritingTestPart1Page(
        testTitle: 'Sample Test',
        testPartData: {
          'note': 'This is a note',
          'q1': 'Sample question?',
          'img': 'assets/sample_image.png',
        },
        selectedPart: 'Part 1',
        selectedTime: '15 minutes',
      ),
    ));

    // Nhấn vào nút submit
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    // Kiểm tra hộp thoại hiển thị
    expect(find.text('Are you sure to submit test?'), findsOneWidget);
    expect(find.text('Yes'), findsOneWidget);
    expect(find.text('No'), findsOneWidget);
  });

  // take picture part 1
  // Kiểm tra khởi tạo bộ đếm thời gian
  testWidgets('Timer initializes and starts correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: TakePictureScreen(remainingTime: Duration(minutes: 1)),
    ));

    // Kiểm tra thời gian ban đầu hiển thị đúng
    expect(find.text('01:00'), findsOneWidget);

    // Chờ 1 giây và kiểm tra thời gian cập nhật
    await tester.pump(Duration(seconds: 1));
    expect(find.text('00:59'), findsOneWidget);
  });

  // Kiểm tra khởi tạo camera
  testWidgets('Camera initializes correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: TakePictureScreen(remainingTime: Duration(minutes: 1)),
    ));

    // Kiểm tra camera đã khởi tạo
    expect(find.byType(CameraPreview), findsOneWidget);
  });

  // Kiểm tra hiển thị hộp thoại khi hết giờ
  testWidgets('Shows time up dialog when timer ends', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: TakePictureScreen(remainingTime: Duration(seconds: 1)),
    ));

    // Giả lập việc hết giờ
    await tester.pump(Duration(seconds: 2));

    // Kiểm tra hộp thoại hiển thị
    expect(find.text('Time is up!'), findsOneWidget);
    expect(find.text('Your time is over. Submitting the test.'), findsOneWidget);
  });

  // Kiểm tra chức năng chụp ảnh
  testWidgets('Capture image and update JSON file', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: TakePictureScreen(remainingTime: Duration(minutes: 1)),
    ));

    // Nhấn vào nút camera
    await tester.tap(find.byIcon(Icons.camera_alt));
    await tester.pumpAndSettle();

    // Kiểm tra hình ảnh đã được chụp và lưu trữ
    expect(find.byType(Image), findsOneWidget);

    // Kiểm tra JSON file được cập nhật
    final directory = await getApplicationDocumentsDirectory();
    final jsonFile = File('${directory.path}/writing_tests.json');
    final jsonData = json.decode(await jsonFile.readAsString());
    expect(jsonData['writing']['test_1']['part_1']['ans'], isNotEmpty);
  });

  // Kiểm tra hộp thoại xác nhận nộp bài
  testWidgets('Shows submit confirmation dialog', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: TakePictureScreen(remainingTime: Duration(minutes: 1)),
    ));

    // Nhấn vào nút submit
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    // Kiểm tra hộp thoại hiển thị
    expect(find.text('Are you sure to submit test?'), findsOneWidget);
    expect(find.text('Yes'), findsOneWidget);
    expect(find.text('No'), findsOneWidget);
  });

  // writing result page
  // Kiểm tra khởi tạo ConfettiController
  testWidgets('ConfettiController initializes and plays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WritingTestResult()));

    // Kiểm tra rằng ConfettiWidget đang hiển thị
    expect(find.byType(ConfettiWidget), findsOneWidget);
  });

  // Kiểm tra TabController khởi tạo đúng cách và chuyển tab
  testWidgets('TabController initializes correctly and switches tabs', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WritingTestResult()));

    // Kiểm tra TabBar và TabBarView khởi tạo đúng cách
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.byType(TabBarView), findsOneWidget);

    // Kiểm tra rằng nội dung của tab đầu tiên đang hiển thị
    expect(find.text('Congratulations!!!'), findsOneWidget);

    // Chuyển sang tab Progress
    await tester.tap(find.text('Progress'));
    await tester.pumpAndSettle();

    // Kiểm tra nội dung của tab Progress đang hiển thị
    expect(find.byType(ProgressPage), findsOneWidget);

    // Chuyển sang tab Personal
    await tester.tap(find.text('Personal'));
    await tester.pumpAndSettle();

    // Kiểm tra nội dung của tab Personal đang hiển thị
    expect(find.byType(ProfilePage), findsOneWidget);
  });

  // 3. speaking
  // Kiểm tra khởi tạo widget và hiển thị các tùy chọn
  testWidgets('PopUpSpeakingSetUpTest initializes correctly and displays options', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: PopUpSpeakingSetUpTest()));

    // Kiểm tra tiêu đề hiển thị đúng
    expect(find.text('Set Up Test'), findsOneWidget);

    // Kiểm tra các tùy chọn 'Choose part'
    expect(find.text('Choose part'), findsOneWidget);
    expect(find.text('Part 1'), findsOneWidget);
    expect(find.text('Part 2'), findsOneWidget);
    expect(find.text('Part 3'), findsOneWidget);
    expect(find.text('Full Part'), findsOneWidget);

    // Kiểm tra các tùy chọn 'Choose time'
    expect(find.text('Choose time'), findsOneWidget);
    expect(find.text('No limit'), findsOneWidget);
    expect(find.text('10 minutes'), findsOneWidget);
    expect(find.text('13 minutes'), findsOneWidget);
  });

  // Kiểm tra chọn phần của bài thi
  testWidgets('User can select test part', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: PopUpSpeakingSetUpTest()));

    // Chọn Part 2
    await tester.tap(find.text('Part 2'));
    await tester.pump();

    // Kiểm tra rằng Part 2 được chọn
    expect(find.byWidgetPredicate((widget) => widget is Radio && widget.value == 'Part 2' && widget.groupValue == 'Part 2'), findsOneWidget);
  });

  // Kiểm tra chọn thời gian của bài thi
  testWidgets('User can select test time', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: PopUpSpeakingSetUpTest()));

    // Mở DropdownButton
    await tester.tap(find.text('No limit'));
    await tester.pumpAndSettle();

    // Chọn 10 minutes
    await tester.tap(find.text('10 minutes').last);
    await tester.pump();

    // Kiểm tra rằng 10 minutes được chọn
    expect(find.text('10 minutes'), findsOneWidget);
  });

  // Kiểm tra khởi tạo widget và hiển thị các thành phần cơ bản
  testWidgets('SearchFilterWidget initializes correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SearchFilterWidget(
          onSearch: (query) {},
          onFavoriteToggle: (showFavoritesOnly) {},
        ),
      ),
    ));

    // Kiểm tra rằng TextField được hiển thị
    expect(find.byType(TextField), findsOneWidget);

    // Kiểm tra rằng DropdownButton được hiển thị
    expect(find.byType(DropdownButton<bool>), findsOneWidget);

    // Kiểm tra rằng có icon search
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  // Kiểm tra chức năng tìm kiếm
  testWidgets('SearchFilterWidget calls onSearch when text is entered', (WidgetTester tester) async {
    String searchText = '';

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SearchFilterWidget(
          onSearch: (query) {
            searchText = query;
          },
          onFavoriteToggle: (showFavoritesOnly) {},
        ),
      ),
    ));

    // Nhập nội dung vào TextField
    await tester.enterText(find.byType(TextField), 'test search');
    await tester.pump();

    // Kiểm tra rằng callback onSearch được gọi với đúng nội dung
    expect(searchText, 'test search');
  });

  // Kiểm tra chức năng chuyển đổi chế độ yêu thích
  testWidgets('SearchFilterWidget calls onFavoriteToggle when dropdown is changed', (WidgetTester tester) async {
    bool showFavoritesOnly = false;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SearchFilterWidget(
          onSearch: (query) {},
          onFavoriteToggle: (favoritesOnly) {
            showFavoritesOnly = favoritesOnly;
          },
        ),
      ),
    ));

    // Mở DropdownButton
    await tester.tap(find.byType(DropdownButton<bool>));
    await tester.pumpAndSettle();

    // Chọn 'Favorites'
    await tester.tap(find.text('Favorites').last);
    await tester.pump();

    // Kiểm tra rằng callback onFavoriteToggle được gọi với giá trị đúng
    expect(showFavoritesOnly, true);
  });

  // Kiểm tra chức năng hiển thị đúng giá trị khi khởi tạo
  testWidgets('SearchFilterWidget displays correct initial value', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SearchFilterWidget(
          onSearch: (query) {},
          onFavoriteToggle: (favoritesOnly) {},
        ),
      ),
    ));

    // Kiểm tra rằng giá trị khởi tạo của DropdownButton là 'All'
    expect(find.text('All'), findsOneWidget);
  });

  // Kiểm tra điều hướng đến SpeakingQuestionPage khi nút "Start" được nhấn
  testWidgets('SpeakingInstructions navigates to SpeakingQuestionPage on Start button press', (WidgetTester tester) async {
    var speakingData = {
      'name': 'Sample Test',
    };
    await tester.pumpWidget(MaterialApp(
      home: SpeakingInstructions(
        part: 'Part 1',
        selectedTime: '10 minutes',
        speakingData: speakingData,
      ),
    ));

    // Nhấn vào nút "Start"
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    // Kiểm tra rằng đã điều hướng đến SpeakingQuestionPage
    expect(find.byType(SpeakingQuestionPage), findsOneWidget);
  });




}
