import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../cubit/test_cubit.dart';
import '../widgets/dropdown.dart';
import '../widgets/practice_item.dart';

//Trang reading
class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key});

  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  List<PracticeTest> list = []; // Danh sách các bài kiểm tra đã lọc
  List<PracticeTest> filteredList = [];
  TextEditingController searchController =
      TextEditingController(); // Bộ điều khiển văn bản cho ô tìm kiếm
  String dropdownValue = "All"; //Giá trị mặc định của dropdown

  @override
  void initState() {
    super.initState();

    // Khởi tạo danh sách các bài kiểm tra
    list = [
      PracticeTest("Reading Practice Test 1", 9, true),
      PracticeTest("Reading Practice Test 2", 10, false),
      PracticeTest("Reading Practice Test 3", 6, true),
      PracticeTest("Reading Practice Test 4", 3, true),
      PracticeTest("Reading Practice Test 5", 1, false),
      PracticeTest("Reading Practice Test 6", 0, true),
      PracticeTest("Reading Practice Test 7", 5, false),
    ];
    filteredList =
        List.from(list); // Sao chép danh sách ban đầu vào danh sách đã lọc
    searchController
        .addListener(_filterTests); // Lắng nghe thay đổi trong ô tìm kiếm
  }

  @override
  void dispose() {
    searchController
        .dispose(); // Giải phóng bộ nhớ cho bộ điều khiển khi không dùng nữa
    super.dispose();
  }

  // Hàm lọc các bài kiểm tra dựa trên ô tìm kiếm và dropdown
  void _filterTests() {
    String query = searchController.text
        .toLowerCase(); // Chuyển văn bản tìm kiếm về chữ thường
    setState(() {
      filteredList = list.where((test) {
        bool matchesQuery = test.name
            .toLowerCase()
            .contains(query); // Kiểm tra tên bài kiểm tra
        bool matchesDropdown = dropdownValue == "All" ||
            (dropdownValue == "Like" &&
                test.star); // Kiểm tra điều kiện dropdown
        return matchesQuery &&
            matchesDropdown; // Kết hợp điều kiện tìm kiếm và dropdown
      }).toList();
    });
  }

  // Hàm xử lý khi thay đổi giá trị dropdown
  void _onDropdownChanged(String value) {
    setState(() {
      dropdownValue = value;
      _filterTests(); // Lọc lại danh sách bài kiểm tra sau khi thay đổi dropdown
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<TestCubit>().loadData(); // Tải dữ liệu từ TestCubit
    return Scaffold(
        appBar: AppBar(
          title: Text('Reading Practice'),
          elevation: 0,
          backgroundColor: Color(0xFFB5E0EA),
        ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Text(
                "\"Skim the passage first, then scan for key words in the questions to find answers quickly.\"",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const Gap(40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 31,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(31),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Gap(14),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                hintText: "Enter test name",
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Image.asset(
                            "assets/images/img_search.png",
                            width: 25,
                            height: 25,
                          ),
                          const Gap(14),
                        ],
                      ),
                    ),
                  ),
                  const Gap(18),
                  Container(
                    width: 130,
                    height: 31,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(31),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Dropdown(
                        onChanged:
                            _onDropdownChanged), // Dropdown để lọc danh sách
                  ),
                ],
              ),
            ),
            const Gap(40),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: ListView.separated(
                  itemCount: filteredList.length,
                  separatorBuilder: (context, index) => const Gap(20),
                  itemBuilder: (context, index) {
                    return PracticeItem(
                        item: filteredList[
                            index]); // Hiển thị từng bài kiểm tra đã lọc
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Lớp mô tả bài kiểm tra thực hành
class PracticeTest {
  final String name;
  final int point;
  final bool star;

  PracticeTest(this.name, this.point, this.star);
}
