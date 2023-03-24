import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mclovin_life_manager/services/notifications_service.dart';

import '../../model/birthday.dart';
import '../../widgets/forms/birthday_form_dialog.dart';
import '../other/loading_widget.dart';

class BirthdayList extends StatefulWidget {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final bool enableNotifications;

  const BirthdayList(
      {required this.firestore,
      required this.firebaseAuth,
      required this.enableNotifications,
      Key? key})
      : super(key: key);

  @override
  State<BirthdayList> createState() => _BirthdayListState();
}

class _BirthdayListState extends State<BirthdayList> {
  List<Birthday> _birthdays = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Birthdays")),
      ),
      body: FutureBuilder(
        future: widget.firestore
            .collection("birthdays")
            .where("ownerId", isEqualTo: widget.firebaseAuth.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return const LoadingWidget();
          }

          _birthdays = snapshot.data!.docs
              .map((e) => Birthday.fromQueryDocumentSnapshot(e))
              .toList();
          Birthday.sortBirthdays(_birthdays);

          if (widget.enableNotifications) {
            for (Birthday birthday in _birthdays) {
              createBirthdayNotification(birthday);
            }
          }

          return ListView.separated(
              padding: const EdgeInsets.all(8),
              itemBuilder: (_, index) {
                Birthday birthday = _birthdays[index];

                return ListTile(
                  key: Key(birthday.id.toString()),
                  title: Text(birthday.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(DateFormat.MMMd().format(birthday.date)),
                      InkWell(
                        onDoubleTap: () {
                          widget.firestore
                              .collection("birthdays")
                              .doc(birthday.id)
                              .delete();
                          setState(() {
                            _birthdays.removeAt(index);
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            size: 30,
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext _, int __) => const Divider(),
              itemCount: _birthdays.length);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) => BirthdayFormDialog(
                  refreshBirthdays: () => setState(() {}),
                  firestore: widget.firestore,
                  firebaseAuth: widget.firebaseAuth,
                )),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void createBirthdayNotification(Birthday birthday) async {
    final currentDate = DateTime.now();

    birthday.date = DateTime(
      currentDate.year,
      birthday.date.month,
      birthday.date.day,
    );
    if (birthday.date.isBefore(currentDate)) {
      birthday.date = DateTime(
        currentDate.year + 1,
        birthday.date.month,
        birthday.date.day,
      );
    }

    await NotificationsService().createNotification(
      id: birthday.id.hashCode,
      title: "Birthday",
      body: "It's ${birthday.name}'s birthday today!",
      dateTime: birthday.date.add(const Duration(hours: 12)),
    );
  }
}
