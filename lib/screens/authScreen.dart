import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/auth/authForm.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  // Application wide State Management isn't necessary.
  // Firebase SDK will manage all relevant State with live connection to the server.
  // It even cache data. So, data is available even the connection is lost temporarily.

  void _submitAuthForm(
    String email,
    String username,
    String password,
    bool isLogin,
    BuildContext contxt,
  ) async {
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await Firestore.instance
            .collection("users")
            .document(authResult.user.uid)
            .setData({
          "userName": username,
          "email": email,
        });
        // 'users' collection will be created on the fly, if not available.
        // '.document(authResult.user.uid)' creates a document,
        // with the id given by the Firebase during the creation of that user account.
        // (i.e) during the Sign up process.
        // '.setData()' stores the data in the document.
      }
    } on PlatformException catch (error) {
      // 'PlatformException' - Errors thrown by Firebase.
      String message = "An error occurred!! Please check your credentials.";

      if (error.message != null) {
        message = error.message;
      }

      Scaffold.of(contxt).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(contxt).errorColor,
        ),
        // 'BuildContext' of the 'AuthForm' is required.
        // Because, 'AuthForm' is the place where all the data are present.
        // 'AuthScreen' just renders 'AuthForm'
      );

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
