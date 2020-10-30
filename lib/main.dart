import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/chatScreen.dart';
import './screens/authScreen.dart';
import './screens/splashScreen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness.dark,
        // 'accentColorBrightness: Brightness.dark' makes color decisions.
        // Ex: 'Colors.deepPurple' is a dark color. So, colors like black will not contrast each other.
        // Thus, lighter colors will be used.
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: ChatApp(),
    );
  }
}

class ChatApp extends StatefulWidget {
  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        // Firebase automatically manages token.
        builder: (contxt, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          if (userSnapshot.hasData) {
            // 'userSnapshot.hasData' checks whether the token is valid.
            return ChatScreen();
          }
          return AuthScreen();
        },
        stream: FirebaseAuth.instance.onAuthStateChanged,
      ),
    );
  }
}

void main() => runApp(MyApp());
