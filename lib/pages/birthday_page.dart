import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mclovin_life_manager/widgets/birthday_form_dialog.dart';
import 'package:mclovin_life_manager/widgets/loading_widget.dart';

import '../model/birthday.dart';

class BirthdayPage extends StatefulWidget {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  const BirthdayPage(
      {required FirebaseFirestore firestore,
      required FirebaseAuth firebaseAuth,
      Key? key})
      : _firebaseAuth = firebaseAuth,
        _firestore = firestore,
        super(key: key);

  @override
  State<BirthdayPage> createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage> {
  List<Birthday> _birthdays = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Birthdays")),
      ),
      body: FutureBuilder(
        future: widget._firestore
            .collection("birthdays")
            .where("ownerId", isEqualTo: widget._firebaseAuth.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return const LoadingWidget();
          }

          _birthdays = snapshot.data!.docs
              .map((e) => Birthday.fromQueryDocumentSnapshot(e))
              .toList();
          Birthday.sortBirthdays(_birthdays);

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
                          widget._firestore
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
                  firestore: widget._firestore,
                  firebaseAuth: widget._firebaseAuth,
                )),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
