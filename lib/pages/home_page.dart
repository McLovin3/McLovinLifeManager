import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widgets/scaffolds/home_scaffold.dart';
import '../widgets/scaffolds/work_scaffold.dart';

class HomePage extends StatefulWidget {
  final bool isDarkTheme;
  final Function changeTheme;
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  const HomePage({
    required this.isDarkTheme,
    required this.changeTheme,
    required this.firestore,
    required this.firebaseAuth,
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isWorkMode = false;
  Uint8List? _background;

  @override
  void initState() {
    refreshImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isWorkMode
        ? WorkScaffold(
            firebaseAuth: widget.firebaseAuth,
            firestore: widget.firestore,
            isDarkTheme: widget.isDarkTheme,
            changeTheme: widget.changeTheme,
            changeMode: changeMode,
            background: _background,
          )
        : HomeScaffold(
            firebaseAuth: widget.firebaseAuth,
            firestore: widget.firestore,
            isDarkTheme: widget.isDarkTheme,
            changeTheme: widget.changeTheme,
            changeMode: changeMode,
            background: _background,
            refreshImage: refreshImage,
          );
  }

  void refreshImage() async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final pathReference = storageRef.child("background.png");
      final Uint8List? image = await pathReference.getData();
      setState(() {
        _background = image;
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  void changeMode() {
    setState(() {
      _isWorkMode = !_isWorkMode;
    });
  }
}
