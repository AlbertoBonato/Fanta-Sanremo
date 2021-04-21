import 'package:cloud_firestore/cloud_firestore.dart';

class Gettone {
  final String id;
  final String name;
  final int points;
  Gettone(this.id, this.name, this.points);

  Gettone.fromDoc(QueryDocumentSnapshot doc)
      : this.id = doc.id,
        this.name = doc.data()['name'],
        this.points = doc.data()['points'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name': name,
    'points': points
  };

}