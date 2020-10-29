import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './messageBubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (contxt, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection("chat")
              .orderBy(
                "messageTime",
                descending: true,
                // By default, ordered in ascending order.
              )
              .snapshots(),
          builder: (contxt, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = chatSnapshot.data.documents;

            // Having 'FutureBuilder()' inside 'StreamBuilder()' fetches the user data
            // again and again for every message, which is useless and redunt.
            // So, 'StreamBuilder()' can be placed inside the 'FutureBuilder()'

            /* return FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (contxt, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } */

            // 'futureSnapshot' gives the data of the current user.
            return ListView.builder(
              itemBuilder: (contxt, index) => MessageBubble(
                chatDocs[index]["text"],
                chatDocs[index]["userName"],
                chatDocs[index]["userImage"],
                chatDocs[index]["userId"] == futureSnapshot.data.uid,
                key: ValueKey(chatDocs[index].documentID),
                // Every message have an unique value(documentID)
                // Every document have an unique 'documentID'
              ),
              itemCount: chatDocs.length,
              reverse: true,
              // 'reverse: true' orders data in a way that they can be scrolled
              // from bottom to top.
            );
          },
        );
      },
    );
  }
}
