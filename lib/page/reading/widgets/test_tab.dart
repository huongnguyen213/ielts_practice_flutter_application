import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../cubit/test_cubit.dart';

class TestTab extends StatefulWidget {
  const TestTab({super.key, required this.part});

  final Part part;

  @override
  State<TestTab> createState() => _TestTabState();
}

class _TestTabState extends State<TestTab> {
  final PageController _controller = PageController();
  final ScrollController _navController = ScrollController();
  int index = 0;
  int prev = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(widget.part.passage),
                  ],
                ),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(12),
              const Text(
                "Choose the correct letter A, B, C or D.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const Gap(12),
              SizedBox(
                height: 170,
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (value) {
                    if (index > prev) {
                      if (value >= 4 && value <= 10) {
                        _navController.animateTo(
                            _navController.offset +
                                _navController.position.maxScrollExtent / 5,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.linear);
                      }
                    }
                    if (index < prev) {
                      if (value >= 3 && value <= 8) {
                        _navController.animateTo(
                            _navController.offset -
                                _navController.position.maxScrollExtent / 5,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.linear);
                      }
                    }
                    setState(() {
                      prev = index;
                      index = value;
                    });
                  },
                  itemCount: widget.part.questions.length,
                  itemBuilder: (context, index) {
                    List<String> data = widget.part.answers[index];
                    return Column(
                      children: [
                        Text(
                          "${index + 1}. ${widget.part.questions[index]}",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const Gap(6),
                        CupertinoButton(
                          onPressed: () {
                            context
                                .read<TestCubit>()
                                .onSelectCorrect(widget.part, index, "A");
                          },
                          minSize: 0,
                          padding: EdgeInsets.zero,
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: widget.part.yourAnswer[index] == "A"
                                      ? const Color(0xff21DE6D)
                                      : const Color(0xffD9D9D9),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              const Gap(12),
                              Expanded(
                                child: Text(
                                  "A. ${data[0]}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(6),
                        CupertinoButton(
                          onPressed: () {
                            context
                                .read<TestCubit>()
                                .onSelectCorrect(widget.part, index, "B");
                          },
                          minSize: 0,
                          padding: EdgeInsets.zero,
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: widget.part.yourAnswer[index] == "B"
                                      ? const Color(0xff21DE6D)
                                      : const Color(0xffD9D9D9),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              const Gap(12),
                              Expanded(
                                child: Text(
                                  "B. ${data[1]}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(6),
                        CupertinoButton(
                          onPressed: () {
                            context
                                .read<TestCubit>()
                                .onSelectCorrect(widget.part, index, "C");
                          },
                          minSize: 0,
                          padding: EdgeInsets.zero,
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: widget.part.yourAnswer[index] == "C"
                                      ? const Color(0xff21DE6D)
                                      : const Color(0xffD9D9D9),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              const Gap(12),
                              Expanded(
                                child: Text(
                                  "C. ${data[2]}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(6),
                        CupertinoButton(
                          onPressed: () {
                            context
                                .read<TestCubit>()
                                .onSelectCorrect(widget.part, index, "D");
                          },
                          minSize: 0,
                          padding: EdgeInsets.zero,
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: widget.part.yourAnswer[index] == "D"
                                      ? const Color(0xff21DE6D)
                                      : const Color(0xffD9D9D9),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              const Gap(12),
                              Expanded(
                                child: Text(
                                  "D. ${data[3]}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        _controller.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linear);
                      },
                      minSize: 0,
                      padding: EdgeInsets.zero,
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      width: 300,
                      child: ListView.separated(
                        controller: _navController,
                        scrollDirection: Axis.horizontal,
                        itemCount: 13,
                        separatorBuilder: (context, index) => const Gap(14),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _controller.animateToPage(index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.linear);
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: widget.part.yourAnswer[index] != ""
                                    ? Colors.greenAccent
                                    : index == this.index
                                    ? Colors.indigo
                                    : const Color(0xffd9d9d9),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child:
                              Center(child: Text((index + 1).toString())),
                            ),
                          );
                        },
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linear);
                      },
                      minSize: 0,
                      padding: EdgeInsets.zero,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _navController.dispose();
    super.dispose();
  }
}
