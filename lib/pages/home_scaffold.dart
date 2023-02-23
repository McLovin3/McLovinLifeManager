import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mclovin_life_manager/pages/todo_page.dart';

import 'birthday_page.dart';

class HomeScaffold extends StatefulWidget {
  final bool isDarkTheme;
  final Function changeMode;
  final Function changeTheme;
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  const HomeScaffold({
    required this.isDarkTheme,
    required this.changeMode,
    required this.changeTheme,
    required this.firestore,
    required this.firebaseAuth,
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      TodoPage(
        isWorkMode: false,
        firebaseAuth: widget.firebaseAuth,
        firestore: widget.firestore,
      ),
      BirthdayPage(
          firebaseAuth: widget.firebaseAuth, firestore: widget.firestore),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Home")),
        actions: [
          IconButton(
            onPressed: () => widget.changeMode(),
            icon: const Icon(Icons.work),
          ),
          IconButton(
            icon: Icon(widget.isDarkTheme ? Icons.sunny : Icons.nightlight),
            onPressed: () => widget.changeTheme(),
          )
        ],
      ),
      body: pages.elementAt(_selectedPage),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Todo",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cake),
            label: "Birthdays",
          ),
        ],
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
      ),
    );
  }
}
