import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

final String GETTONE_EVENT_TYPE = 'gettone';
final String QUESTION_EVENT_TYPE = 'question';

class Event {
  final String id;
  final DateTime insertDate;
  final String type;
  String key;
  final int points;
  Event(
      { this.id,
      @required this.insertDate,
      @required this.type,
      @required this.key,
      @required this.points});

  Event.fromDoc(QueryDocumentSnapshot doc)
      : this.id = doc.id,
        this.insertDate = doc.data()['insert-date'],
        this.type = doc.data()['type'],
        this.key = doc.data()['key'],
        this.points = doc.data()['points'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'insert-date': insertDate,
        'type': type,
        'key': key,
        'points': points
      };

  Map<String, dynamic> toJsonNoId() => {
    'insert-date': insertDate,
    'type': type,
    'key': key,
    'points': points
  };
}
