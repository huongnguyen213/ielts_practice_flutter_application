import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../cubit/test_cubit.dart';
import '../widgets/dropdown.dart';
import '../widgets/practice_item.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key});

  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  List<PracticeTest> list = [];
  List<PracticeTest> filteredList = [];
  TextEditingController searchController = TextEditingController();
  String dropdownValue = "All";

  @override
  void initState() {
    super.initState();
    list = [
      PracticeTest("Reading Practice Test 1", 9, true),
      PracticeTest("Reading Practice Test 2", 10, false),
      PracticeTest("Reading Practice Test 3", 6, true),
      PracticeTest("Reading Practice Test 4", 3, true),
      PracticeTest("Reading Practice Test 5", 1, false),
      PracticeTest("Reading Practice Test 6", 0, true),
      PracticeTest("Reading Practice Test 7", 5, false),
    ];
    filteredList = List.from(list);
    searchController.addListener(_filterTests);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterTests() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = list.where((test) {
        bool matchesQuery = test.name.toLowerCase().contains(query);
        bool matchesDropdown =
            dropdownValue == "All" || (dropdownValue == "Like" && test.star);
        return matchesQuery && matchesDropdown;
      }).toList();
    });
  }

  void _onDropdownChanged(String value) {
    setState(() {
      dropdownValue = value;
      _filterTests();
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<TestCubit>().loadData();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xffB5E0EA),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          color: const Color(0xffB5E0EA),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                padding: EdgeInsets.zero,
                minSize: 0,
                child: Image.asset(
                  "assets/images/img_back.png",
                  width: 43,
                  height: 50,
                ),
              ),
              const Text(
                "Reading Practice",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Gap(43),
            ],
          ),
        ),
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
                    child: Dropdown(onChanged: _onDropdownChanged),
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
                    return PracticeItem(item: filteredList[index]);
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

class PracticeTest {
  final String name;
  final int point;
  final bool star;

  PracticeTest(this.name, this.point, this.star);
}
