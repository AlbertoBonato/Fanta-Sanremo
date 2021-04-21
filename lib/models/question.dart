import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String id;
  String demand;
  String answer1;
  String answer2;
  String answer3;
  String answer4;
  int correctAnswer;
  final int index;
  bool visible;

  Question.fromDoc(QueryDocumentSnapshot doc)
      : this.id = doc.id,
        this.demand = doc.data()['demand'],
        this.answer1 = doc.data()['answer1'],
        this.answer2 = doc.data()['answer2'],
        this.answer3 = doc.data()['answer3'],
        this.answer4 = doc.data()['answer4'],
        this.correctAnswer = doc.data()['correctAnswer'],
        this.index = doc.data()['index'],
        this.visible = doc.data()['visible'];

  Question.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.demand = json['demand'],
        this.answer1 = json['answer1'],
        this.answer2 = json['answer2'],
        this.answer3 = json['answer3'],
        this.answer4 = json['answer4'],
        this.correctAnswer = json['correctAnswer'],
        this.index = json['index'],
        this.visible = json['visible'];

  @override
  bool operator ==(Object other) {
    Question otherQuestion = (other as Question);
    return this.index == otherQuestion.index;
  }

  @override
  String toString() {
    return '{id: $id, demand: $demand, answer1: $answer1, '
        'answer2: $answer2, answer3: $answer3, answer4: $answer4, '
        'correctAnswer: $correctAnswer, index: $index, visible: $visible}';
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'demand': demand,
    'answer1': answer1,
    'answer2': answer2,
    'answer3': answer3,
    'answer4': answer4,
    'correctAnswer': correctAnswer,
    'index': index,
    'visible': visible
  };
}
