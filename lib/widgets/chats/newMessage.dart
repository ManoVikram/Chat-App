import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = "";

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    // All authentication works are managed by Firebase behind the scenes.
    final currentUser = await FirebaseAuth.instance.currentUser();
    final currentUserData = await Firestore.instance
        .collection("users")
        .document(currentUser.uid)
        .get();
    Firestore.instance.collection("chat").add(
      {
        "text": _enteredMessage,
        "messageTime": Timestamp.now(),
        // 'Timestamp' is provided by 'cloud_firestore' package.
        "userId": currentUser.uid,
        "userName": currentUserData["userName"],
        "userImage": currentUserData["imageURL"],
      },
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              // 'TextField' in a 'Row' causes an error as it tries to take up too much space.
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Send a message...",
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
