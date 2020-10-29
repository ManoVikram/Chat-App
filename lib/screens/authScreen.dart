import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
    File userImage,
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

        // 'FirebaseStorage' is used to upload image to Firebase.
        // In Firebase Storage all files are organized inside buckets.
        // 1 main bucket is available by default.
        // Here, we work on buckets and paths in buckets.

        // In this app, users can only upload and view image, not edit.
        final reference = FirebaseStorage.instance
            .ref()
            .child("userImages")
            .child(authResult.user.uid + ".jpg");
        // 'userImages' folder is created in the bucket, where the image is stored.
        // '.ref()' gives access / points to the root cloud storage main bucket by default.
        // '.child(authResult.user.uid)' gives name to the image that is stored.
        // A reference / pointer is set to the 'userImage/authResult.user.uid + ".jpg"' path.

        await reference.putFile(userImage).onComplete;
        // '.putFile()' actually uploads the image to the path set up by 'reference'
        // '.putFile()' takes time to upload the image.
        // Thus, '.onComplete' is used to convert it into 'Future', so that 'await' can be used.
        // 'StorageMetadata()' can be sent as 2nd argument(optional).

        final imageURL = await reference.getDownloadURL();
        // '.getDownloadURL()' gets the direct link to the image.

        await Firestore.instance
            .collection("users")
            .document(authResult.user.uid)
            .setData({
          "userName": username,
          "email": email,
          "imageURL": imageURL,
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
