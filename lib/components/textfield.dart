import 'package:flutter/material.dart';

//Design for textfields

class textField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool hideText;
  final String labelText;
  final TextInputType keyboardType;

  const textField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.hideText,
      required this.labelText,
      required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: hideText,
        decoration: InputDecoration(
          labelText: labelText,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
      ),
    );
  }
}
