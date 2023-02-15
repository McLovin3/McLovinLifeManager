import 'package:cloud_firestore/cloud_firestore.dart';

class Birthday {
  String id;
  String ownerId;
  DateTime date;

  Birthday(
    this.id,
    this.ownerId,
    this.date,
  );

  static Birthday fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> json) {
    return Birthday(
      json.id,
      json.data()["ownerId"],
      DateTime.parse(json.data()["date"]),
    );
  }
}
