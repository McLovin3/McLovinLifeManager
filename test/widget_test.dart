import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mclovin_life_manager/main.dart';

import 'package:mclovin_life_manager/widgets/lists/birthday_list.dart';
import 'package:mclovin_life_manager/widgets/lists/item_list_list.dart';
import 'package:mclovin_life_manager/widgets/lists/todo_list.dart';

Future<void> main() async {
  // Initialize Firebase Auth
  final user = MockUser(
    isAnonymous: false,
    uid: '123456',
    email: 'mathieu.ford@gmail.com',
    displayName: 'Mathieu Ford',
  );
  final auth = MockFirebaseAuth(mockUser: user);
  await auth.signInWithEmailAndPassword(
      email: "mathieu.ford@gmail.com", password: "password");

  // Initialize Firebase Firestore
  final firestore = FakeFirebaseFirestore();
  await firestore.collection("todos").add({
    "action": "Do stuff",
    "dueDate": "2023-02-20",
    "isWork": false,
    "ownerId": "123456"
  });
  await firestore.collection("todos").add({
    "action": "Do work stuff",
    "dueDate": "2023-02-20",
    "isWork": true,
    "ownerId": "123456"
  });
  await firestore.collection("birthdays").add({
    "name": "Mathieu Ford",
    "date": "2002-10-11",
    "ownerId": "123456",
  });
  await firestore.collection("itemlists").add({
    "ownerId": "123456",
    "title": "List of stuff",
    "items": ["item1"]
  });
  await firestore.collection("journals").add({
    "ownerId": "123456",
    "text": "Today I did super cool stuff",
    "writeDate": "2023-02-17"
  });

  testWidgets("Both modes test", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(
      firestore: firestore,
      firebaseAuth: auth,
      lightLevel: 50,
    ));
    await tester.pump();

    expect(find.text("Do stuff"), findsOneWidget);

    debugDumpApp();
    await tester.tap(find.byIcon(Icons.work));
    await tester.pumpAndSettle();

    expect(find.text("Do work stuff"), findsOneWidget);
  });

  testWidgets("Shows todo test", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        title: "Test app",
        home: TodoList(
          firestore: firestore,
          firebaseAuth: auth,
          isWorkMode: false,
        )));
    await tester.pump();

    expect(find.text("Do stuff"), findsOneWidget);
  });

  testWidgets("Remove todo test", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        title: "Test app",
        home: TodoList(
          firestore: firestore,
          firebaseAuth: auth,
          isWorkMode: false,
        )));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.check));
    await tester.pump(kDoubleTapMinTime);
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    expect(find.text("Do stuff"), findsNothing);
  });

  testWidgets("Add todo test", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        title: "Test app",
        home: TodoList(
            firestore: firestore, firebaseAuth: auth, isWorkMode: false)));
    await tester.pump();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key("action")), "Do more stuff");
    await tester.tap(find.text("Confirm"));
    await tester.pumpAndSettle();

    expect(find.text("Do more stuff"), findsOneWidget);
    expect(find.text(DateFormat.MMMd().format(DateTime.now())), findsOneWidget);
  });

  testWidgets("Shows birthday test", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        title: "Test app",
        home: BirthdayList(
          firestore: firestore,
          firebaseAuth: auth,
          enableNotifications: false,
        )));
    await tester.pump();

    expect(find.text("Mathieu Ford"), findsOneWidget);
    expect(find.text("Oct 11"), findsOneWidget);
  });

  testWidgets("Remove birthday test", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        title: "Test app",
        home: BirthdayList(
          firestore: firestore,
          firebaseAuth: auth,
          enableNotifications: false,
        )));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump(kDoubleTapMinTime);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text("Mathieu Ford"), findsNothing);
  });

  testWidgets("Add birthday test", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        title: "Test app",
        home: BirthdayList(
          firestore: firestore,
          firebaseAuth: auth,
          enableNotifications: false,
        )));
    await tester.pump();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key("name")), "Joe Biden");
    await tester.tap(find.text("Confirm"));
    await tester.pumpAndSettle();

    expect(find.text("Joe Biden"), findsOneWidget);
    expect(find.text(DateFormat.MMMd().format(DateTime.now())), findsOneWidget);
  });

  testWidgets("App starts on correct theme day test",
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(
      firestore: firestore,
      firebaseAuth: auth,
      lightLevel: 50,
    ));
    await tester.pump();

    expect(find.byIcon(Icons.nightlight), findsOneWidget);
  });

  testWidgets("App starts on correct theme night test",
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(
      firestore: firestore,
      firebaseAuth: auth,
      lightLevel: 0,
    ));
    await tester.pump();

    expect(find.byIcon(Icons.sunny), findsOneWidget);
  });

  testWidgets("Change between themes test", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(
      firestore: firestore,
      firebaseAuth: auth,
      lightLevel: 50,
    ));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.nightlight));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.sunny), findsOneWidget);

    await tester.tap(find.byIcon(Icons.sunny));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.nightlight), findsOneWidget);
  });

  testWidgets("show lists tests", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        title: "Test app",
        home: ItemListList(firestore: firestore, firebaseAuth: auth)));
    await tester.pump();

    expect(find.text("List of stuff"), findsOneWidget);
  });

  testWidgets("show items in list test", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(
      firebaseAuth: auth,
      firestore: firestore,
      lightLevel: 50,
    ));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.list_alt));
    await tester.pumpAndSettle();
    await tester.tap(find.text("List of stuff"));
    await tester.pumpAndSettle();

    expect(find.text("item1"), findsOneWidget);
  });

  testWidgets("delete list item test", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(
      firebaseAuth: auth,
      firestore: firestore,
      lightLevel: 50,
    ));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.list_alt));
    await tester.pumpAndSettle();
    await tester.tap(find.text("List of stuff"));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump(kDoubleTapMinTime);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text("item1"), findsNothing);
  });

  testWidgets("add list item test", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(
      firebaseAuth: auth,
      firestore: firestore,
      lightLevel: 50,
    ));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.list_alt));
    await tester.pumpAndSettle();
    await tester.tap(find.text("List of stuff"));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key("text")), "Item2");
    await tester.tap(find.text("Submit"));
    await tester.pumpAndSettle();

    expect(find.text("Item2"), findsOneWidget);
  });

  testWidgets("delete list tests", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        title: "Test app",
        home: ItemListList(firestore: firestore, firebaseAuth: auth)));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump(kDoubleTapMinTime);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text("List of stuff"), findsNothing);
  });

  testWidgets("add list test", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(
      firebaseAuth: auth,
      firestore: firestore,
      lightLevel: 50,
    ));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.list_alt));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key("text")), "Second list");
    await tester.tap(find.text("Submit"));
    await tester.pumpAndSettle();

    expect(find.text("Second list"), findsOneWidget);
  });

  testWidgets("See journals test", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(
      firebaseAuth: auth,
      firestore: firestore,
      lightLevel: 50,
    ));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.book));
    await tester.pumpAndSettle();

    expect(find.text("Feb 17"), findsOneWidget);
  });

  testWidgets("See journal entry test", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(
      firebaseAuth: auth,
      firestore: firestore,
      lightLevel: 50,
    ));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.book));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Feb 17"));
    await tester.pumpAndSettle();

    expect(find.text("Today I did super cool stuff"), findsOneWidget);
  });

  testWidgets("Delete a journal test", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(
      firebaseAuth: auth,
      firestore: firestore,
      lightLevel: 50,
    ));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.book));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump(kDoubleTapMinTime);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text("Feb 17"), findsNothing);
  });

  testWidgets("Add journal test", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(
      firebaseAuth: auth,
      firestore: firestore,
      lightLevel: 50,
    ));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.book));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byKey(const Key("text")), "I did cool things today");
    await tester.tap(find.text("Submit"));
    await tester.pumpAndSettle();

    expect(find.text(DateFormat.MMMd().format(DateTime.now())), findsOneWidget);
  });

  testWidgets("breathing aid test", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(
      firebaseAuth: auth,
      firestore: firestore,
      lightLevel: 50,
    ));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.nature));
    await tester.pumpAndSettle();

    expect(find.text("60"), findsOneWidget);

    await tester.tap(find.text("Start"));
    await tester.pump();
  });
}
