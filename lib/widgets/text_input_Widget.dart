import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  const TextFieldInput(
      {super.key,
      required this.input,
      required this.hintText,
      required this.keyboardType,
      this.obsecureText = false});
  final TextEditingController input;
  final String hintText;
  final TextInputType keyboardType;
  final bool obsecureText;
  @override
  Widget build(BuildContext context) {
    final inputborder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: input,
      decoration: InputDecoration(
          hintText: hintText,
          focusedBorder: inputborder,
          enabledBorder: inputborder,
          filled: true,
          contentPadding: const EdgeInsets.all(12)),
      keyboardType: keyboardType,
      obscureText: obsecureText,
    );
  }
}
