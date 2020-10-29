import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String userName;
  final String imageURL;
  final bool isMe;
  final Key key;
  // 'key' is required while working with huge list of data(Here, messages.)
  // 'key' helps Flutter in uniquely identifying a message.
  // Helps Flutter in efficiently updating and re-rendering the messages list.

  MessageBubble(
    this.message,
    this.userName,
    this.imageURL,
    this.isMe, {
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: !isMe ? Radius.zero : Radius.circular(15),
                  bottomRight: isMe ? Radius.zero : Radius.circular(15),
                ),
                color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 8,
              ),
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              width: 200,
              // 'Container()' is wrapped inside a 'Row'
              // Because, 'width:' will be ignored as it is inside 'ListView'
              // Typically, 'MessageBubble()' is used inside 'ListView' in message.dart
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* FutureBuilder(
                  // 'FutureBuilder()' fetches the userId for every single message.
                  // New request is made for every message bubble being rendered.
                  // This might exceed the number of API request calls.
                  future: Firestore.instance
                      .collection("users")
                      .document(userId)
                      .get(),
                  // '.get()' will get the data from the document through 'Future'
                  builder: (contxt, snapshot) {
                    // 'snapshot' holds the data about the user.)
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    Text(
                      snapshot.data["userName"],
                      style: TextStyle(
                        color: isMe ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ), */
                  Text(
                    userName,
                    style: TextStyle(
                      color: isMe
                          ? Colors.green
                          : Theme.of(context).accentTextTheme.headline1.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -5,
          left: !isMe ? 195 : null,
          right: isMe ? 195 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(imageURL),
          ),
        ),
        // 'Positioned()' helps in positioning the widget's place(2D-position) in the stack.
      ],
      overflow: Overflow.visible,
    );
  }
}
