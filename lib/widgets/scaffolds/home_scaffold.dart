import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../lists/birthday_list.dart';
import '../lists/event_list.dart';
import '../lists/item_list_list.dart';
import '../lists/journal_list.dart';
import '../lists/todo_list.dart';
import '../other/breathing_aid.dart';
import '../other/fidget_zone.dart';

class HomeScaffold extends StatefulWidget {
  final bool isDarkTheme;
  final Function changeTheme;
  final Function changeMode;
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  const HomeScaffold({
    required this.isDarkTheme,
    required this.changeTheme,
    required this.changeMode,
    required this.firestore,
    required this.firebaseAuth,
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  int _selectedPage = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    pages = [
      TodoList(
        isWorkMode: false,
        firebaseAuth: widget.firebaseAuth,
        firestore: widget.firestore,
      ),
      BirthdayList(
        firebaseAuth: widget.firebaseAuth,
        firestore: widget.firestore,
        enableNotifications: true,
      ),
      ItemListList(
        firebaseAuth: widget.firebaseAuth,
        firestore: widget.firestore,
      ),
      JournalList(
        firestore: widget.firestore,
        firebaseAuth: widget.firebaseAuth,
      ),
      EventList(
        firestore: widget.firestore,
        firebaseAuth: widget.firebaseAuth,
        enableNotifications: true,
        isWorkMode: false,
      ),
      const BreathingAid(),
      const FidgetZone(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Home")),
        actions: [
          IconButton(
            onPressed: () => widget.changeMode(),
            icon: const Icon(Icons.work),
          ),
          IconButton(
            onPressed: () => widget.changeTheme(),
            icon: Icon(widget.isDarkTheme ? Icons.sunny : Icons.nightlight),
          )
        ],
      ),
      body: pages.elementAt(_selectedPage),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Todo",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cake),
            label: "Birthdays",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Lists",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Journal",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Events",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.nature),
            label: "Breathing Aid",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.toys),
            label: "Fidget",
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedPage = index;
          });
        },
      ),
    );
  }
}
