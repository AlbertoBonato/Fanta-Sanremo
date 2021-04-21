import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserGettone {
  String name;
  DateTime selectionDate;

  UserGettone(this.name, this.selectionDate);

  UserGettone.noValue()
      : this.name = null,
        this.selectionDate = null;

  @deprecated
  UserGettone.create(this.name) : this.selectionDate = DateTime.now();

  UserGettone.createWithDate(this.name, this.selectionDate);

  UserGettone.fromJson(Map<String, dynamic> json)
      : this.name = json['name'],
        this.selectionDate = json['selection-date']?.toDate();

  Map<String, dynamic> toJson() {
    return {'name': name, 'selection-date': selectionDate};
  }
}

class UserPoints {
  int total;
  List<String> eventIds;

  UserPoints()
      : this.total = 0,
        this.eventIds = [];

  UserPoints.plain(this.total, this.eventIds);

  UserPoints.fromJson(Map<String, dynamic> json) {
    this.total = json['total'];
    dynamic jsonEventIds = json['event-ids'];
    if (jsonEventIds != null && jsonEventIds != "[]")  {
      this.eventIds = List<String>.from(jsonEventIds.toList());
    } else {
      this.eventIds = [];
    }
  }

  Map<String, dynamic> toJson() {
    return {'total': total, 'event-ids': jsonEncode(eventIds)};
  }
}

class User {
  final String id;
  String groupId;
  final String firebaseUid;
  final String name;
  String bet;
  UserGettone gettone;
  UserPoints points;

  User(this.id, this.groupId, this.firebaseUid, this.name, this.bet)
      : this.gettone = UserGettone.noValue(),
        this.points = UserPoints();

  User.nullo()
      : this.id = null,
        this.firebaseUid = null,
        this.name = null;

  User.fromDoc(DocumentSnapshot doc)
      : this.id = doc.id,
        this.groupId = doc.data()['group-id'],
        this.firebaseUid = doc.data()['firebase-uid'],
        this.bet = doc.data()['bet'],
        this.gettone = UserGettone.fromJson(doc.data()['gettone']),
        this.name = doc.data()['name'],
        this.points = UserPoints.fromJson(doc.data()['points']);

  User.fromQueryDoc(QueryDocumentSnapshot doc)
      : this.id = doc.id,
        this.groupId = doc.data()['group-id'],
        this.firebaseUid = doc.data()['firebase-uid'],
        this.gettone = UserGettone.fromJson(doc.data()['gettone']),
        this.name = doc.data()['name'],
        this.bet = doc.data()['bet'],
        this.points = UserPoints.fromJson(doc.data()['points']);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group-id': groupId,
      'firebase-uid': firebaseUid,
      'gettone':
          (gettone != null) ? gettone.toJson() : UserGettone.noValue().toJson(),
      'name': name,
      'bet': bet,
      'points': (points != null) ? points.toJson() : UserPoints().toJson()
    };
  }

  Map<String, dynamic> toJsonNoId() {
    return {
      'group-id': groupId,
      'firebase-uid': firebaseUid,
      'gettone':
          (gettone != null) ? gettone.toJson() : UserGettone.noValue().toJson(),
      'name': name,
      'points': (points != null) ? points.toJson() : UserPoints().toJson()
    };
  }
}
