import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String id;
  final String name;
  final List<String> membersUid;
  Group(this.id, this.name, this.membersUid);

  Group.fromDoc(DocumentSnapshot doc)
      : this.id = doc.id,
        this.name = doc.data()['name'],
        this.membersUid = List<String>.from(doc.data()['members-uid'].toList());

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name': name,
      'membersUid' : jsonEncode(this.membersUid)
    };
  }
}
