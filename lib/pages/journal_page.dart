import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mclovin_life_manager/model/journal.dart';

class JournalPage extends StatelessWidget {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  const JournalPage(
      {required this.firebaseAuth, required this.firestore, super.key});

  @override
  Widget build(BuildContext context) {
    Journal journal = ModalRoute.of(context)!.settings.arguments as Journal;

    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat.MMMd().format(journal.writeDate)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            journal.text,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
