import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GeneralScaffold extends StatefulWidget {
  final String title;
  final bool isDarkTheme;
  final bool isWorkMode;
  final int selectedPage;
  final Function changeTheme;
  final List<Widget> pages;
  final BottomNavigationBar? bottomNavigationBar;
  final Function changeMode;
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  const GeneralScaffold({
    required this.pages,
    required this.selectedPage,
    required this.bottomNavigationBar,
    required this.title,
    required this.isWorkMode,
    required this.isDarkTheme,
    required this.changeTheme,
    required this.changeMode,
    required this.firestore,
    required this.firebaseAuth,
    Key? key,
  }) : super(key: key);

  @override
  State<GeneralScaffold> createState() => _GeneralScaffoldState();
}

class _GeneralScaffoldState extends State<GeneralScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
        actions: [
          IconButton(
            onPressed: () => widget.changeMode(),
            icon: Icon(widget.isWorkMode ? Icons.work : Icons.home),
          ),
          IconButton(
            icon: Icon(widget.isDarkTheme ? Icons.sunny : Icons.nightlight),
            onPressed: () => widget.changeTheme(),
          )
        ],
      ),
      body: widget.pages.elementAt(widget.selectedPage),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
