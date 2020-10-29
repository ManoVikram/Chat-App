import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) userPickedImage;

  UserImagePicker(this.userPickedImage);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  Future<void> _pickImage(bool isCamera) async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return;
    }
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.userPickedImage(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.amber,
          backgroundImage: _pickedImage != null
              ? FileImage(_pickedImage)
              : AssetImage("lib/assets/images/userImage.png"),
        ),
        /* IconButton(
          icon: Icon(Icons.image),
          onPressed: _pickImage,
        ), */
        DropdownButton(
          icon: Icon(
            Icons.image,
            color: Theme.of(context).buttonColor,
          ),
          elevation: 7,
          items: [
            DropdownMenuItem(
              child: Text("Camera"),
              value: "camera",
            ),
            DropdownMenuItem(
              child: Text("Gallery"),
              value: "gallery",
            ),
          ],
          onChanged: (value) {
            if (value == "camera") {
              _pickImage(true);
            }
            _pickImage(false);
          },
        ),
      ],
      alignment: AlignmentDirectional.bottomEnd,
    );
  }
}
