import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mclovin_life_manager/model/todo.dart';
import 'package:mclovin_life_manager/widgets/loading_widget.dart';
import 'package:mclovin_life_manager/widgets/todo_form_dialog.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<StatefulWidget> createState() => TodoPageState();
}

class TodoPageState extends State<TodoPage> {
  static List<Todo> todos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("TODO")),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("todos")
            .where("ownerId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return const LoadingWidget();
          }

          todos = snapshot.data!.docs
              .map((e) => Todo.fromQueryDocumentSnapshot(e))
              .toList();

          todos.sort((a, b) => a.dueDate.compareTo(b.dueDate));

          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemBuilder: (BuildContext _, int index) {
              return ListTile(
                key: Key(todos[index].id.toString()),
                title: Text(todos[index].action),
                trailing: Text(todos[index].dueDate.toString().split(" ")[0]),
              );
            },
            itemCount: todos.length,
            separatorBuilder: (BuildContext _, int __) => const Divider(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) => const TodoFormDialog()),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void addTodo(Todo todo) {
    setState(() {
      todos.add(todo);
    });
  }
}
