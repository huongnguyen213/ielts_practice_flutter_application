import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../cubit/test_cubit.dart';
import '../widgets/drawable_answers.dart';
import '../widgets/test_tab.dart';

//Hiển thị solution
class SolutionPage extends StatelessWidget {
  const SolutionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey =
        GlobalKey<ScaffoldState>(); // Khóa để quản lý Scaffold
    return BlocBuilder<TestCubit, TestState>(
      // Sử dụng BlocBuilder để lắng nghe trạng thái từ TestCubit
      builder: (context, state) {
        // Tạo danh sách Tab từ danh sách các phần (parts) được chọn
        List<Tab> tabs =
            state.choosePart.map((e) => Tab(text: "Part $e")).toList();
        // Tạo danh sách các TabView từ danh sách các phần (parts) được chọn
        List<Widget> tabViews = state.choosePart.map((e) {
          Part part = state.parts[e - 1];
          return TestTab(part: part);
        }).toList();
        return DefaultTabController(
          length: state.choosePart.length, // Số lượng tab sẽ hiển thị
          child: Scaffold(
            key: scaffoldKey,
            // Sử dụng khóa Scaffold
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
                tabs: tabs, // Danh sách các tab
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
                        Navigator.of(context).pop(); // Quay lại trang trước đó
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
                      "Solution", // Tiêu đề trang
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const Gap(43), // Khoảng trống giữa các phần tử
                  ],
                ),
              ),
            ),
            endDrawer: const DrawableAnswers(),
            // Menu ngăn kéo ở phía bên phải để hiển thị câu trả lời có thể vẽ
            body: TabBarView(children: tabViews), // Nội dung của các tab
          ),
        );
      },
    );
  }
}
