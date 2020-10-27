import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 7,
                      ),
                      Text("Logout"),
                    ],
                  ),
                ),
                value: "logout",
              ),
            ],
            onChanged: (dropdownItem) {
              // 'dropdownItem' is the item identifier.
              if (dropdownItem == "logout") {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
          SizedBox(
            width: 7,
          ),
        ],
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection("/chats/j4M9nexdOSou7fzJG92l/messages/")
              .snapshots(),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final documents = streamSnapshot.data.documents;
            // print(documents[0].data);
            return ListView.builder(
              itemBuilder: (contxt, index) => Container(
                child: Text(documents[index].data["text"]),
                padding: EdgeInsets.all(10),
              ),
              itemCount: documents.length,
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /* Firestore.instance
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
          // '.collection()' takes in path to the 'collection' or the 'sub-collection'.
          // '.snapshots()' returns a 'Stream'
          // Since it is a 'Stream', it emmits new values whenever data changes. */

          Firestore.instance
              .collection("/chats/j4M9nexdOSou7fzJG92l/messages")
              .add({
            "text": "You clicked the add button!!",
          });
          // '.add()' adds a new document to the Firebase(Firestore) in the messages collection.
        },
        elevation: 5,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
