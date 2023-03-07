import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource s) async {
  ImagePicker pick = ImagePicker();
  XFile? file = await pick.pickImage(source: s, imageQuality: 75);
  if (file != null) {
    return file.readAsBytes();
  }
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
