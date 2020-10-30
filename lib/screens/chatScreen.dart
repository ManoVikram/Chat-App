import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../widgets/chats/messages.dart';
import '../widgets/chats/newMessage.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    // It's a better practice to have 'super.initState()' on the top.
    final firebaseMessaging = FirebaseMessaging();
    firebaseMessaging.requestNotificationPermissions();
    // '.requestNotificationPermissions()' will not do anything on Android devices.
    // But, asks for permission on iOS devices.
    // Documentation - 'https://pub.dev/packages/firebase_messaging/versions/6.0.16'
    firebaseMessaging.configure(
      // 'onMessage:' - When the app is running.
      // When the app is running, no notification will be received.
      // But, the message/information will be displayed on the terminal log.
      onMessage: (message) {
        print(message);
        return;
      },
      // 'onLaunch:' - When the app is launched.
      onLaunch: (message) {
        print(message);
        return;
      },
      // 'onResume:' - When the app running in the background.
      onResume: (message) {
        print(message);
        return;
      },
    );
    // firebaseMessaging.getToken();
    // '.getToken()' helps sending notifications to specific devices
    // with the help of those device tokens.
    firebaseMessaging.subscribeToTopic("chat");
    // '.subscribeToTopic(topic)' subscribes to a particular topic.
    // Notification reaches this device, when any notification reaches this topic.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        actions: [
          DropdownButton(
            underline: Container(),
            // Passing 'Container()' to 'underline:' will remove the underline
            // present below the dropdown button.
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
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
              // 'Messages()' renders 'ListView'
              // ListView performs poor in a Column
              // Thus, 'Messages()' needs to be wrapped inside 'Expanded()'
            ),
            NewMessage(),
          ],
        ),
      ),
      /* floatingActionButton: FloatingActionButton(
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
      ), */
    );
  }
}
