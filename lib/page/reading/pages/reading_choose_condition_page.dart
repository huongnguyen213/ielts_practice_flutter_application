import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:ielts_practice_flutter_application/page/reading/pages/test_page.dart';

import '../cubit/test_cubit.dart';
import '../widgets/time_dropdown.dart';

// Trang lựa chọn điều kiện cho bài thi reading
class ReadingChooseConditionPage extends StatefulWidget {
  const ReadingChooseConditionPage({super.key});

  @override
  State<ReadingChooseConditionPage> createState() =>
      _ReadingChooseConditionPageState();
}

class _ReadingChooseConditionPageState
    extends State<ReadingChooseConditionPage> {
  // Các biến bool để kiểm tra phần nào được chọn
  bool p1 = false;
  bool p2 = false;
  bool p3 = false;
  bool p4 = false;
  String time = "Standard"; //// Thời gian mặc định

  // Hàm xử lý khi thay đổi giá trị dropdown
  void _handleDropdownChanged(String newValue) {
    time = newValue;
  }

  @override
  Widget build(BuildContext context) {
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
            const Gap(65),
            const Text(
              "Set up test",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const Gap(65),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 38),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "1. Choose part",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const Gap(32),
                  Row(
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          onPressed: () {
                            setState(() {
                              p1 = !p1;
                              p2 = false;
                              p3 = false;
                              p4 = false;
                            });
                          },
                          minSize: 0,
                          padding: EdgeInsets.zero,
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: p1
                                      ? const Color(0xff21DE6D)
                                      : const Color(0xffD9D9D9),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              const Gap(12),
                              const Text(
                                "Part 1",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: CupertinoButton(
                          onPressed: () {
                            setState(() {
                              p2 = !p2;
                              p1 = false;
                              p3 = false;
                              p4 = false;
                            });
                          },
                          minSize: 0,
                          padding: EdgeInsets.zero,
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: p2
                                      ? const Color(0xff21DE6D)
                                      : const Color(0xffD9D9D9),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              const Gap(12),
                              const Text(
                                "Part 2",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(29),
                  Row(
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          onPressed: () {
                            setState(() {
                              p1 = false;
                              p2 = false;
                              p3 = !p3;
                              p4 = false;
                            });
                          },
                          minSize: 0,
                          padding: EdgeInsets.zero,
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: p3
                                      ? const Color(0xff21DE6D)
                                      : const Color(0xffD9D9D9),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              const Gap(12),
                              const Text(
                                "Part 3",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: CupertinoButton(
                          onPressed: () {
                            setState(() {
                              p1 = false;
                              p2 = false;
                              p3 = false;
                              p4 = !p4;
                            });
                          },
                          minSize: 0,
                          padding: EdgeInsets.zero,
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: p4
                                      ? const Color(0xff21DE6D)
                                      : const Color(0xffD9D9D9),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              const Gap(12),
                              const Text(
                                "Full Part",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(32),
                  const Text(
                    "2. Choose time",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const Gap(24),
                  Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xffF1EDED),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TimeDropdown(onChanged: _handleDropdownChanged),
                  ),
                ],
              ),
            ),
            const Gap(80),
            CupertinoButton(
              onPressed: () {
                int chooseTime = time == "Standard" ? 10 : int.parse(time);
                List<int> choosePart = [];

                if (p4) {
                  choosePart.clear();
                  choosePart.add(1);
                  choosePart.add(2);
                  choosePart.add(3);
                } else {
                  if (p1) {
                    choosePart.add(1);
                  }
                  if (p2) {
                    choosePart.add(2);
                  }
                  if (p3) {
                    choosePart.add(3);
                  }
                }

                if (p1 != false || p2 != false || p3 != false || p4 != false) {
                  context.read<TestCubit>().setUpTest(choosePart, chooseTime);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TestPage()));
                }
              },
              color: const Color(0xffB5E0EA),
              minSize: 0,
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 9, horizontal: 72),
                child: Text(
                  "Start",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
