import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFunc;
  UserImagePicker(this.imagePickFunc);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickdImage;

  void _pickImage() async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() => _pickdImage = image);
    widget.imagePickFunc(_pickdImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: _pickdImage != null ? FileImage(_pickdImage) : null,
          backgroundColor: Colors.grey,
          radius: 30,
        ),
        FlatButton.icon(
          icon: Icon(Icons.image),
          label: Text('Add Image'),
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
        ),
      ],
    );
  }
}
