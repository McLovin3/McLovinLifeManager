import 'package:cloud_firestore/cloud_firestore.dart';

class Birthday {
  String id;
  String ownerId;
  String name;
  DateTime date;

  Birthday(
    this.id,
    this.ownerId,
    this.name,
    this.date,
  );

  static void sortBirthdays(List<Birthday> birthdays) {
    DateTime currentDate = DateTime.now();
    int cutOffIndex = 0;

    birthdays.sort((a, b) {
      if (a.date.month == b.date.month) {
        return a.date.day.compareTo(b.date.day);
      }

      return a.date.month.compareTo(b.date.month);
    });

    for (int i = 0; i < birthdays.length; i++) {
      Birthday birthday = birthdays.elementAt(i);

      if (birthday.date.month < currentDate.month ||
          (birthday.date.month == currentDate.month &&
              birthday.date.day < currentDate.day)) {
        cutOffIndex++;
      }
    }

    List<Birthday> temp = birthdays.sublist(0, cutOffIndex);
    birthdays.removeRange(0, cutOffIndex);
    birthdays.addAll(temp);
  }

  static Birthday fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> json) {
    return Birthday(
      json.id,
      json.data()["ownerId"],
      json.data()["name"],
      DateTime.parse(json.data()["date"]),
    );
  }
}
