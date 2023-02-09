import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mclovin_life_manager/model/todo.dart';
import 'package:mclovin_life_manager/widgets/loading_widget.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<StatefulWidget> createState() => TodoPageState();
}

class TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("todos")
          .where("ownerId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return const LoadingWidget();
        }

        List<Todo> todos = snapshot.data!.docs
            .map((e) => Todo.fromQueryDocumentSnapshot(e))
            .toList();

        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemBuilder: (BuildContext _, int index) {
            return ListTile(
              key: Key(todos[index].id.toString()),
              title: Text(todos[index].action),
            );
          },
          itemCount: todos.length,
          separatorBuilder: (BuildContext _, int __) => const Divider(),
        );
      },
    );
  }
}
