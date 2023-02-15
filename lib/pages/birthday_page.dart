import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mclovin_life_manager/widgets/loading_widget.dart';

import '../model/birthday.dart';

class BirthdayPage extends StatefulWidget {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  const BirthdayPage(
      {required this.firestore, required this.firebaseAuth, Key? key})
      : super(key: key);

  @override
  State<BirthdayPage> createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage> {
  List<Birthday> birthdays = [];

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

          birthdays = snapshot.data!.docs
              .map((e) => Birthday.fromQueryDocumentSnapshot(e))
              .toList();
          Birthday.sortBirthdays(birthdays);

          return ListView.separated(
              padding: const EdgeInsets.all(8),
              itemBuilder: (_, index) {
                Birthday birthday = birthdays[index];

                return ListTile(
                  key: Key(birthday.id.toString()),
                  title: Text(birthday.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("${birthday.date.month}-${birthday.date.day}"),
                      IconButton(
                        onPressed: () {
                          widget.firestore
                              .collection("birthdays")
                              .doc(birthday.id)
                              .delete();
                          setState(() {
                            birthdays.remove(birthday);
                          });
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext _, int __) => const Divider(),
              itemCount: birthdays.length);
        },
      ),
    );
  }
}
