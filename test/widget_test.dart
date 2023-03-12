import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mclovin_life_manager/main.dart';

import 'package:mclovin_life_manager/widgets/lists/birthday_list.dart';
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
        home: BirthdayList(firestore: firestore, firebaseAuth: auth)));
    await tester.pump();

    expect(find.text("Mathieu Ford"), findsOneWidget);
    expect(find.text("Oct 11"), findsOneWidget);
  });

  testWidgets("Remove birthday test", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        title: "Test app",
        home: BirthdayList(firestore: firestore, firebaseAuth: auth)));
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
        home: BirthdayList(firestore: firestore, firebaseAuth: auth)));
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
}
