import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemBuilder: (contxt, index) => Text("helloWorl!!"),
          itemCount: 10,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Firestore.instance
              .collection("/chats/j4M9nexdOSou7fzJG92l/messages/")
              .snapshots()
              .listen(
            (data) {
              print(data);
              print(data.documents);
              print(data.documents[0]["text"]);
              // 'text' is the key in messages collection.
              data.documents.forEach((document) {
                print(document["text"]);
              });
            },
          );
          // https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/learn/lecture/19510396?start=0#overview
          // The video in the above link explains the setting up of firebase.
          // '.collection()' takes in path to the collection or the sub-collection.
          // '.snapshots()' returns a 'Stream'
          // Since it is a 'Stream', it emmits new values whenever data changes.
        },
        elevation: 5,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
