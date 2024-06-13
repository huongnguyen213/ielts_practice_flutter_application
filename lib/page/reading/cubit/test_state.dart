part of 'test_cubit.dart';

final class TestState extends Equatable {
  final List<Part> parts;
  final int time;
  final List<int> choosePart;

  const TestState({
    required this.parts,
    required this.time,
    required this.choosePart,
  });

  TestState copyWith({
    List<Part>? parts,
    int? time,
    List<int>? choosePart,
  }) {
    return TestState(
      parts: parts ?? this.parts,
      time: time ?? this.time,
      choosePart: choosePart ?? this.choosePart,
    );
  }

  @override
  List<Object> get props => [parts, time, choosePart];
}

class Part extends Equatable {
  final String passage;
  final List<String> questions;
  final List<List<String>> answers;
  final List<String> yourAnswer;
  final List<String> correctAnswer;

  const Part({
    required this.passage,
    required this.questions,
    required this.answers,
    required this.yourAnswer,
    required this.correctAnswer,
  });

  factory Part.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataQuestions = json["questions"];
    List<String> questions = dataQuestions.map((e) => e.toString()).toList();
    List<dynamic> dataCorrectAnswer = json["correctAnswer"];
    List<String> correctAnswer =
        dataCorrectAnswer.map((e) => e.toString()).toList();
    List<dynamic> dataAnswers = json["answers"];
    List<List<String>> answers = [];
    for (var e in dataAnswers) {
      List<dynamic> dataAnswersOfQuestion = e;
      List<String> answersOfQuestion =
          dataAnswersOfQuestion.map((e) => e.toString()).toList();
      answers.add(answersOfQuestion);
    }

    return Part(
      passage: json["passage"],
      questions: questions,
      answers: answers,
      yourAnswer: List<String>.filled(13, ""),
      correctAnswer: correctAnswer,
    );
  }

  Part copyWith({
    String? passage,
    List<String>? questions,
    List<List<String>>? answers,
    List<String>? yourAnswer,
    List<String>? correctAnswer,
  }) {
    return Part(
      passage: passage ?? this.passage,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      yourAnswer: yourAnswer ?? this.yourAnswer,
      correctAnswer: correctAnswer ?? this.correctAnswer,
    );
  }

  @override
  List<Object> get props => [
        passage,
        questions,
        answers,
        yourAnswer,
        correctAnswer,
      ];
}
