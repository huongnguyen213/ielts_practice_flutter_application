//Quản lý trạng thái của bài kiểm tra, bao gồm giữ liệu json, thiết lập bài kiểm tra, cập nhật câu trả lời người dùng
// cubit sẽ phát ra trạng thái mới mỗi khi có sự thay đổi, Ui fluter update theo
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'test_state.dart';
// Khởi tạo trạng thái ban đầu cho Cubit với danh sách parts rỗng, time = 0
class TestCubit extends Cubit<TestState> {
  TestCubit() : super(const TestState(parts: [], time: 0, choosePart: []));

// loadData Đọc dữ liệu từ file json trong assets
  void loadData() async {
    String data = await rootBundle.loadString("assets/mock/data.json");
    List<dynamic> jsonResponse = json.decode(data);
    List<Part> parts = jsonResponse.map((e) => Part.fromJson(e)).toList(); // Giải mã json thành các danh sách các đối tượng part
    emit(state.copyWith(parts: parts));// phát ra trạng thái mới với danh sách được cập nhật
  }
// Thiết lập bài kiểm tra với các phần đc chọn  và time làm bài
  void setUpTest(List<int> choosePart, int time) {
    emit(state.copyWith(choosePart: choosePart, time: time)); // trạng thái mới và time đc update
  }

  //Update câu trả lời , tạo bản sao , cập nhật câu hỏi đã chọn, phát ra trạng thái mới
  void onSelectCorrect(Part part, int numOfQuestion, String answer) {
    List<Part> current = List.from(state.parts);
    int numOfPart = current.indexOf(part);
    List<String> yourAnswers = List.from(part.yourAnswer);
    yourAnswers[numOfQuestion] = answer;
    current[numOfPart] = current[numOfPart].copyWith(yourAnswer: yourAnswers);
    emit(state.copyWith(parts: current));
  }
}
