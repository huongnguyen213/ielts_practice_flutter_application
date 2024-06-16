import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../cubit/test_cubit.dart';
import '../pages/test_result_page.dart';
// Widget DrawableAnswers là một StatelessWidget hiển thị câu trả lời dựa trên trạng thái của TestCubit.
// Nếu chỉ có một phần được chọn, nó sẽ hiển thị các câu trả lời trong một cột.
// Nếu có nhiều phần được chọn, nó sẽ hiển thị các câu trả lời trong nhiều cột.

class DrawableAnswers extends StatelessWidget {
  const DrawableAnswers({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestCubit, TestState>(
      // Sử dụng BlocBuilder để xây dựng widget dựa trên trạng thái của TestCubit

      builder: (context, state) {
        if (state.choosePart.length == 1) {
          // Kiểm tra nếu chỉ có một phần được chọn

          int index=0;
          List<Widget>answers = state.parts[state.choosePart[0]-1].yourAnswer.map((e) {
            // Tạo danh sách các widget Text để hiển thị câu trả lời


            ++index;
           if(e==""){
             return Text(
               "$index. _",
               style: const TextStyle(
                 fontSize: 20,
                 fontWeight: FontWeight.w400,
                 color: Colors.black,
               ),
             );
           }else{
             return Text(
               "$index. ${state.parts[state.choosePart[0] - 1].yourAnswer[index-1]}",
               style: const TextStyle(
                 fontSize: 20,
                 fontWeight: FontWeight.w400,
                 color: Colors.black,
               ),
             );
           }
          }).toList();
          return Drawer(
            // Tạo một Drawer để hiển thị các câu trả lời


            child: SafeArea(
              child: Column(
                children: [
                  const Gap(60), // Tạo khoảng cách 60px
                  const Text(
                    "Answers",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const Gap(24),
                  Column(children: answers), // Hiển thị danh sách các câu trả lời
                  const Gap(60),
                  CupertinoButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            onTap: Navigator.of(context).pop,
                            // Đóng dialog khi chạm ra ngoài

                            child: Container(
                              color: Colors.black.withOpacity(0.1),
                              child: Center(
                                child: Container(
                                  width: 350,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      const Gap(24),
                                      const Text(
                                        "Are you sure to submit test ?",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CupertinoButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              minSize: 0,
                                              color: const Color(0xff8ed1e0),
                                              padding: const EdgeInsets.all(20),
                                              child: const Text(
                                                "No",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            CupertinoButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                    const TestResultPage(),
                                                    // Điều hướng đến trang TestResultPage khi nhấn nút "Yes"
                                                  ),
                                                );
                                              },
                                              minSize: 0,
                                              color: const Color(0xffe09d8e),
                                              padding: const EdgeInsets.all(20),
                                              child: const Text(
                                                "Yes",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    minSize: 0,
                    padding: EdgeInsets.zero,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xff84e182),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          // Trường hợp có nhiều phần được chọn

          int index=0;
          List<Widget>answers1 = state.parts[state.choosePart[0]-1].yourAnswer.map((e) {
            ++index;
            if(e==""){
              return Text(
                "$index. _",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              );
            }else{
              return Text(
                "$index. ${state.parts[state.choosePart[0] - 1].yourAnswer[index-1]}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              );
            }
          }).toList();

          index=0;
          List<Widget>answers2 = state.parts[state.choosePart[1]-1].yourAnswer.map((e) {
            ++index;
            if(e==""){
              return Text(
                "$index. _",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              );
            }else{
              return Text(
                "$index. ${state.parts[state.choosePart[1] - 1].yourAnswer[index-1]}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              );
            }
          }).toList();

          index=0;
          List<Widget>answers3 = state.parts[state.choosePart[2]-1].yourAnswer.map((e) {
            ++index;
            if(e==""){
              return Text(
                "$index. _",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              );
            }else{
              return Text(
                "$index. ${state.parts[state.choosePart[2] - 1].yourAnswer[index-1]}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              );
            }
          }).toList();

          return Drawer(  //Tạo Drawer với nhiều cột hiển thị các phần câu trả lời khác nhau
            child: SafeArea(
              child: Column(
                children: [
                  const Gap(60),
                  const Text(
                    "Answers",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const Gap(24),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: answers1,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: answers2,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: answers3,
                        ),
                      ),
                    ],
                  ),
                  const Gap(60),
                  CupertinoButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            onTap: Navigator.of(context).pop,
                            child: Container(
                              color: Colors.black.withOpacity(0.1),
                              child: Center(
                                child: Container(
                                  width: 350,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      const Gap(24),
                                      const Text(
                                        "Are you sure to submit test ?",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CupertinoButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Đóng dialog khi chạm ra ngoài
                                              },
                                              minSize: 0,
                                              color: const Color(0xff8ed1e0),
                                              padding: const EdgeInsets.all(20),
                                              child: const Text(
                                                "No",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            CupertinoButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                    const TestResultPage(), // Điều hướng đến trang TestResultPage khi nhấn nút "Yes"
                                                  ),
                                                );
                                              },
                                              minSize: 0,
                                              color: const Color(0xffe09d8e),
                                              padding: const EdgeInsets.all(20),
                                              child: const Text(
                                                "Yes",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    minSize: 0,
                    padding: EdgeInsets.zero,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xff84e182),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

