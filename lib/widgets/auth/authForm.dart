import 'dart:io';

import 'package:flutter/material.dart';

import '../../pickers/userImagePicker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String username,
    String password,
    File userImage,
    bool isLogin,
    BuildContext contxt,
  ) submitFunction;
  final bool isLoading;

  AuthForm(this.submitFunction, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = "";
  String _userName = "";
  String _userPassword = "";
  bool _isLogin = true;
  File _userImage;

  void _userPickedImage(File image) {
    _userImage = image;
  }

  void _trySubmit() {
    print("Hello");
    print(_userEmail);
    print(_userName);
    print(_userPassword);
    print("World");

    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    // Helps in closing the keyboard.
    // Basically, it moves the focus from any field to nothing.

    if (_userImage == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Please pick an image."),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      // '.save()' triggers 'onSaved:' on every 'TextFormField()'
      print(_userEmail);
      print(_userName);
      print(_userPassword);

      // 'authScreen.dart' handles all the Form related Firebase interactions.

      // '_userImage' will be null if in Login mode.
      widget.submitFunction(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _userImage,
        _isLogin,
        context,
      );
      // '.trim()' removes the blank spaces at the start or end of a string.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // 'Column()' usually takes as much height as available.
                // 'mainAxisSize: MainAxisSize.min' makes the Column() take only the required height.
                children: [
                  if (!_isLogin) UserImagePicker(_userPickedImage),
                  TextFormField(
                    key: ValueKey("email"),
                    // 'key:' helps in uniquely identifying data.
                    // Flutter internally uses it for identification and prevent mis-matches.
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    validator: (value) {
                      if (value.isEmpty ||
                          !value.contains("@") ||
                          !value.contains(".")) {
                        return "Enter a valid Email id";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey("username"),
                      decoration: InputDecoration(
                        labelText: "Username",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter a valid username.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey("password"),
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty || value.length < 8) {
                        return "Enter a valid password with at least 8 characters.";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      onPressed: _trySubmit,
                      child: Text(
                        _isLogin ? "Login" : "Signup",
                      ),
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                          // UI needs to be updated when changed.
                        });
                      },
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        _isLogin
                            ? "Create new account"
                            : "Already have an account? Try Login.",
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
