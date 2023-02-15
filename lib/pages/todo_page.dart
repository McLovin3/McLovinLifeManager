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
      {required this.firestore, required this.firebaseAuth, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late final List<Todo> _todos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("TODO")),
        backgroundColor: Colors.pinkAccent,
      ),
      body: FutureBuilder(
        future: widget.firestore
            .collection("todos")
            .where("ownerId", isEqualTo: widget.firebaseAuth.currentUser!.uid)
            .get(),
        builder: (_, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return const LoadingWidget();
          }

          _todos = snapshot.data!.docs
              .map((e) => Todo.fromQueryDocumentSnapshot(e))
              .toList();

          _todos.sort((a, b) => a.dueDate.compareTo(b.dueDate));

          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemBuilder: (_, index) {
              Todo todo = _todos.elementAt(index);

              return ListTile(
                key: Key(todo.id.toString()),
                title: Text(todo.action),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        "${todo.dueDate.year}-${todo.dueDate.month}-${todo.dueDate.day}"),
                    IconButton(
                      onPressed: () {
                        widget.firestore
                            .collection("todos")
                            .doc(todo.id)
                            .delete();
                        setState(() {
                          _todos.removeAt(index);
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
            itemCount: _todos.length,
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
