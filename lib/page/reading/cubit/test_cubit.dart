import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'test_state.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit() : super(const TestState(parts: [], time: 0, choosePart: []));

  void loadData() async {
    String data = await rootBundle.loadString("assets/mock/data.json");
    List<dynamic> jsonResponse = json.decode(data);
    List<Part> parts = jsonResponse.map((e) => Part.fromJson(e)).toList();
    emit(state.copyWith(parts: parts));
  }

  void setUpTest(List<int> choosePart, int time) {
    emit(state.copyWith(choosePart: choosePart, time: time));
  }

  void onSelectCorrect(Part part, int numOfQuestion, String answer) {
    List<Part> current = List.from(state.parts);
    int numOfPart = current.indexOf(part);
    List<String> yourAnswers = List.from(part.yourAnswer);
    yourAnswers[numOfQuestion] = answer;
    current[numOfPart] = current[numOfPart].copyWith(yourAnswer: yourAnswers);
    emit(state.copyWith(parts: current));
  }
}
