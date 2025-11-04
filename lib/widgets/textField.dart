import 'package:flutter/material.dart';

class TextFieldW extends StatefulWidget {
  final TextEditingController controller;
  final String hintTxt;
  final String labelTxt;
  final Icon icon;
  const TextFieldW(
      {super.key,
      required this.labelTxt,
      required this.icon,
      required this.hintTxt,
      required this.controller,
      required String? Function(dynamic value) validator});

  @override
  State<TextFieldW> createState() => _TextFieldWState();
}

class _TextFieldWState extends State<TextFieldW> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(right: 25, left: 25),
        child: TextField(
          controller: widget.controller,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: widget.labelTxt,
              hintText: widget.hintTxt,
              suffixIcon: GestureDetector(
                child: widget.icon,
              )),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
