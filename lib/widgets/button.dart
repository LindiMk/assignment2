import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const MyButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(9)),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 25, fontWeight: FontWeight.w400, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
