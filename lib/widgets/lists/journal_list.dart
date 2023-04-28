import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mclovin_life_manager/model/journal.dart';

import '../../widgets/other/loading_widget.dart';
import '../forms/text_input_dialog.dart';

class JournalList extends StatefulWidget {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  const JournalList(
      {required this.firestore, required this.firebaseAuth, Key? key})
      : super(key: key);

  @override
  State<JournalList> createState() => _JournalListState();
}

class _JournalListState extends State<JournalList> {
  List<Journal> _journalList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Journal")),
      ),
      body: FutureBuilder(
        future: widget.firestore
            .collection("journals")
            .where("ownerId", isEqualTo: widget.firebaseAuth.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return const LoadingWidget();
          }

          _journalList = snapshot.data!.docs
              .map((e) => Journal.fromQueryDocumentSnapshot(e))
              .toList();
          _journalList.sort((a, b) => b.writeDate.compareTo(a.writeDate));

          return ListView.separated(
              padding: const EdgeInsets.all(8),
              itemBuilder: (_, index) {
                Journal journal = _journalList[index];

                return ListTile(
                  key: Key(journal.id.toString()),
                  title: Text(DateFormat.MMMd().format(journal.writeDate)),
                  onTap: () {
                    Navigator.pushNamed(context, "/journal",
                        arguments: journal);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onDoubleTap: () {
                          widget.firestore
                              .collection("journals")
                              .doc(journal.id)
                              .delete();
                          setState(() {
                            _journalList.removeAt(index);
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
              itemCount: _journalList.length);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => TextInputDialog(
            hintText: "text",
            onSubmit: (String text) {
              widget.firestore.collection("journals").add({
                "text": text,
                "ownerId": widget.firebaseAuth.currentUser!.uid,
                "writeDate": DateTime.now().toString().split(" ")[0],
              });
              setState(() => {});
            },
            title: "Write a new journal entry",
            maxLines: 10,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.transparent,
    );
  }
}
