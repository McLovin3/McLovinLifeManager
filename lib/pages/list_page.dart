import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mclovin_life_manager/model/item_list.dart';

class ListPage extends StatefulWidget {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final bool isDarkTheme;

  const ListPage(
      {required this.firestore,
      required this.firebaseAuth,
      required this.isDarkTheme,
      super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    final itemList = ModalRoute.of(context)!.settings.arguments as ItemList;

    return Scaffold(
      appBar: AppBar(
        title: Text(itemList.title),
      ),
      body: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemBuilder: (_, index) {
            String item = itemList.items[index];

            return ListTile(
              key: Key(index.toString()),
              title: Text(item),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onDoubleTap: () {
                      setState(() {
                        itemList.items.removeAt(index);
                      });
                      widget.firestore
                          .collection("itemlists")
                          .doc(itemList.id)
                          .update({"items": itemList.items});
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        size: 30,
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext _, int __) => const Divider(),
          itemCount: itemList.items.length),
    );
  }
}
