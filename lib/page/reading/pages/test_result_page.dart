import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:ielts_practice_flutter_application/page/reading/pages/solution_page.dart';
import 'package:pie_chart/pie_chart.dart';

import '../cubit/test_cubit.dart';
import '../widgets/linear_point.dart';

class TestResultPage extends StatelessWidget {
  const TestResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/images/img_ielts.png",
                    width: 64,
                    height: 53,
                  ),
                  Image.asset(
                    "assets/images/img_notification.png",
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
              Image.asset(
                "assets/images/img_cat.png",
                width: 83,
                height: 46,
              ),
              BlocBuilder<TestCubit, TestState>(
                builder: (context, state) {
                  int correct = 0;
                  int wrong = 0;
                  int notYetDone = 0;
                  for (var e in state.choosePart) {
                    for (int x = 0;
                    x < state.parts[e - 1].yourAnswer.length;
                    x++) {
                      if (state.parts[e - 1].yourAnswer[x] == "") {
                        notYetDone++;
                      } else if (state.parts[e - 1].yourAnswer[x] ==
                          state.parts[e - 1].correctAnswer[x]) {
                        correct++;
                      } else {
                        wrong++;
                      }
                    }
                  }

                  Map<String, double> dataMap = {
                    "Correct": double.parse(correct.toString()) *
                        100 /
                        (correct + wrong + notYetDone),
                    "Wrong": double.parse(wrong.toString()) *
                        100 /
                        (correct + wrong + notYetDone),
                    "Not yet done": double.parse(notYetDone.toString()) *
                        100 /
                        (correct + wrong + notYetDone),
                  };
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Gap(80),
                      PieChart(dataMap: dataMap),
                      const Gap(60),
                      Text(
                        "Score: $correct/${correct + wrong + notYetDone}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      const Gap(12),
                      LinearPoint(point: correct),
                      const Gap(32),
                      Text(
                        "Consumption time: ${state.time} min",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      const Gap(12),
                      const LinearPoint(point: 9),
                    ],
                  );
                },
              ),
              const Gap(48),
              CupertinoButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SolutionPage()));
                },
                minSize: 0,
                color: const Color(0xffcbebc3),
                padding: EdgeInsets.zero,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: const Text(
                    "View solution",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
