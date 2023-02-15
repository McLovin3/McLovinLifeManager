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

  static void sortBirthdays(List<Birthday> birthdays) {
    birthdays.sort((a, b) {
      if (a.date.month == b.date.month) {
        return a.date.day.compareTo(b.date.day);
      } else {
        return a.date.month.compareTo(b.date.month);
      }
    });
  }

  static Birthday fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> json) {
    return Birthday(
      json.id,
      json.data()["ownerId"],
      DateTime.parse(json.data()["date"]),
    );
  }
}
