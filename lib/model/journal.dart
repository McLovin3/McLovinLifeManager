import 'package:cloud_firestore/cloud_firestore.dart';

class Journal {
  String id;
  String ownerId;
  String text;
  DateTime writeDate;

  Journal(
    this.id,
    this.ownerId,
    this.text,
    this.writeDate,
  );

  static Journal fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> json) {
    return Journal(
      json.id,
      json.data()["ownerId"],
      json.data()["text"],
      DateTime.parse(json.data()["writeDate"]),
    );
  }
}
