import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mclovin_life_manager/model/todo.dart';
import 'package:mclovin_life_manager/widgets/loading_widget.dart';
import 'package:mclovin_life_manager/widgets/todo_form_dialog.dart';

class TodoPage extends StatefulWidget {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  const TodoPage(
      {required this.firestore, required this.firebaseAuth, super.key});

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
        future: widget.firestore
            .collection("todos")
            .where("ownerId", isEqualTo: widget.firebaseAuth.currentUser!.uid)
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(todos[index].dueDate.toString().split(" ")[0]),
                    IconButton(
                      onPressed: () {
                        widget.firestore
                            .collection("todos")
                            .doc(todos[index].id)
                            .delete();
                        setState(() {
                          todos.removeAt(index);
                        });
                      },
                      icon: const Icon(
                        Icons.check,
                      ),
                      color: Colors.green,
                    ),
                  ],
                ),
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
            builder: (context) => TodoFormDialog(
                  refreshTodos: refreshTodos,
                  firestore: widget.firestore,
                  firebaseAuth: widget.firebaseAuth,
                )),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void refreshTodos() {
    setState(() {});
  }
}
