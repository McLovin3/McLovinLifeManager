import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String location;
  String details;
  DateTime date;
  bool isWork;

  Event(
    this.id,
    this.location,
    this.details,
    this.date,
    this.isWork,
  );

  static Event fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> json) {
    return Event(
      json.id,
      json.data()["location"],
      json.data()["details"],
      DateTime.parse(json.data()["date"]),
      json.data()["isWork"],
    );
  }
}
