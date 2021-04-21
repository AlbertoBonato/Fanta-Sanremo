import 'dart:convert';
import 'dart:io';

import 'package:fanta_sanremo/models/question.dart';
import 'package:fanta_sanremo/utils/utils.dart';

class QuizState {
  List<QuestionState> questionStates = <QuestionState>[];

  @override
  String toString() {
    return 'QuizState{questionStates: $questionStates}';
  }

  QuizState() : this.questionStates = <QuestionState>[];

  QuizState.fromJson(Map<String, dynamic> json)
    : this.questionStates = QuestionState.listFromJson(json);

  Map<String, dynamic> toJson() => <String, dynamic>{
      'questionStates' : QuestionState.toJsonList(this.questionStates)
  };

  Future<void> persist() async {
    final file = await _localFile;
    if (this.questionStates.isNotEmpty) {
      await file.writeAsString(jsonEncode(this));
    }
  }
}

class QuestionState {
  Question question;
  bool opened = false;
  bool completed = false;
  int givenAnswerIndex = 0;
  QuestionState(this.question);

  @override
  String toString() {
    return '{question: $question, opened: $opened, completed: $completed, givenAnswerIndex: $givenAnswerIndex}';
  }

  Map<String, dynamic> toJson() => <String, dynamic> {
    'question' : this.question.toJson(),
    'opened' : this.opened,
    'completed' : this.completed,
    'givenAnswerIndex' : this.givenAnswerIndex,
  };

  QuestionState.fromJson(Map<String, dynamic> json)
    : this.question  = Question.fromJson(json['question']),
  this.opened = json['opened'],
  this.completed = json['completed'],
  this.givenAnswerIndex = json['givenAnswerIndex'];

  static List<QuestionState> listFromJson(Map<String, dynamic> json) {
    List<dynamic> jsonList = List.from(json['questionStates']);
    return jsonList.map((e) => QuestionState.fromJson(e)).toList();
  }

  static List<dynamic> toJsonList(List<QuestionState> qStates) {
    return qStates.map((e) => e.toJson()).toList();
  }
}

Future<File> get _localFile async {
  final path = await localPath;
  return File('$path/quiz_state.txt');
}

Future<QuizState> readQuizState() async {
  try {
    final file = await _localFile;
    String contents = await file.readAsString();
    QuizState quizState = QuizState.fromJson(jsonDecode(contents));
    return quizState;
  } catch (e) {
    print('error reading quiz state $e');
    return QuizState();
  }
}
