import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../pages/todo_page.dart';

class WorkScaffold extends StatefulWidget {
  final bool isDarkTheme;
  final Function changeTheme;
  final Function changeMode;
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  const WorkScaffold({
    required this.isDarkTheme,
    required this.changeTheme,
    required this.changeMode,
    required this.firestore,
    required this.firebaseAuth,
    Key? key,
  }) : super(key: key);

  @override
  State<WorkScaffold> createState() => _WorkScaffoldState();
}

class _WorkScaffoldState extends State<WorkScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Work")),
        actions: [
          IconButton(
            onPressed: () => widget.changeMode(),
            icon: const Icon(Icons.home),
          ),
          IconButton(
            onPressed: () => widget.changeTheme(),
            icon: Icon(widget.isDarkTheme ? Icons.sunny : Icons.nightlight),
          )
        ],
      ),
      body: TodoPage(
        isWorkMode: true,
        firebaseAuth: widget.firebaseAuth,
        firestore: widget.firestore,
      ),
    );
  }
}
