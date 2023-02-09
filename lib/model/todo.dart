import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String id;
  String ownerId;
  String action;
  DateTime dueDate;
  bool isWork;

  static Todo fromQueryDocumentSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    return Todo(
      json.id,
      json.data()["ownerId"],
      json.data()["action"],
      DateTime.parse(json.data()["dueDate"]),
      json.data()["isWork"],
    );
  }

  Todo(
    this.id,
    this.ownerId,
    this.action,
    this.dueDate,
    this.isWork,
  );
}
