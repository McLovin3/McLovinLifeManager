import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/scaffolds/home_scaffold.dart';
import '../widgets/scaffolds/work_scaffold.dart';

class HomePage extends StatefulWidget {
  final bool isDarkTheme;
  final Function changeTheme;
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  const HomePage(
      {required this.isDarkTheme,
      required this.changeTheme,
      required this.firestore,
      required this.firebaseAuth,
      Key? key})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isWorkMode = false;

  @override
  Widget build(BuildContext context) {
    return _isWorkMode
        ? WorkScaffold(
            firebaseAuth: widget.firebaseAuth,
            firestore: widget.firestore,
            isDarkTheme: widget.isDarkTheme,
            changeTheme: widget.changeTheme,
            changeMode: changeMode,
          )
        : HomeScaffold(
            firebaseAuth: widget.firebaseAuth,
            firestore: widget.firestore,
            isDarkTheme: widget.isDarkTheme,
            changeTheme: widget.changeTheme,
            changeMode: changeMode,
          );
  }

  void changeMode() {
    setState(() {
      _isWorkMode = !_isWorkMode;
    });
  }
}
