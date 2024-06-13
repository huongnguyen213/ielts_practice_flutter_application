import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../cubit/test_cubit.dart';
import '../widgets/count_down_time.dart';
import '../widgets/drawable_answers.dart';
import '../widgets/test_tab.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return BlocBuilder<TestCubit, TestState>(
      builder: (context, state) {
        List<Tab> tabs =
        state.choosePart.map((e) => Tab(text: "Part $e")).toList();
        List<Widget> tabViews = state.choosePart.map((e) {
          Part part = state.parts[e - 1];
          return TestTab(part: part);
        }).toList();
        return DefaultTabController(
          length: state.choosePart.length,
          child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              actions: const [Gap(0)],
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Color(0xffE2F1F4),
              ),
              bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.black.withOpacity(0.25),
                labelColor: Colors.black,
                tabs: tabs,
              ),
              title: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                color: const Color(0xffE2F1F4),
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
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/img_clock.png",
                          width: 40,
                          height: 40,
                        ),
                        const Gap(12),
                        CountDownTime(target: state.time),
                      ],
                    ),
                    CupertinoButton(
                      onPressed: () {
                        scaffoldKey.currentState!.openEndDrawer();
                      },
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      child: Image.asset(
                        "assets/images/img_option.png",
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            endDrawer: const DrawableAnswers(),
            body: TabBarView(children: tabViews),
          ),
        );
      },
    );
  }
}
