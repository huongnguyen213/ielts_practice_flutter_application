//quản lý trạng thái, lưu trữ và xử lý dữ liệu trong ứng dụng
part of 'test_cubit.dart'; // chia thư viện dart thành nhiều file

// Lớp testState
final class TestState extends Equatable {     //Khai báo biến có tên Final có tên testState và kế thừa Equa
  final List<Part> parts; // ds đối tượng part
  final int time;
  final List<int> choosePart; //  ds số nguyên biểu thị các phần đc chọn

  const TestState({       // const chỉ ra contructor có thể sử dụng tạo ra các hằng số biên dịch
    required this.parts,
    required this.time,
    required this.choosePart,
  });

  TestState copyWith({    // coppy with tạo bản sao của tesState
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
  List<Object> get props => [parts, time, choosePart];  // ghì đè phương thức props, cung cấp ds cần dc so sánh
}

class Part extends Equatable {
  final String passage;
  final List<String> questions;
  final List<List<String>> answers;
  final List<String> yourAnswer;
  final List<String> correctAnswer;

  const Part({
    required this.passage, // đoạn văn bản
    required this.questions, // ds câu hỏi
    required this.answers, // ds câu trả lời
    required this.yourAnswer, // ds câu trả lời người dùng
    required this.correctAnswer, // ds câu trả lời đúng
  });


  //
  factory Part.fromJson(Map<String, dynamic> json) {    // tạo đối tượng part từ json
    List<dynamic> dataQuestions = json["questions"];
    List<String> questions = dataQuestions.map((e) => e.toString()).toList(); // các ds đc lấy từ json
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

  Part copyWith({ // tạo bản sao của part 1 số thuộc tính thay đổi
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
