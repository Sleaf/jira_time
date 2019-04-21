import 'package:flutter/material.dart';

class PlaceholderText extends StatelessWidget {
  final String text;

  const PlaceholderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      transform: Matrix4.translationValues(0, -50, 0),
      child: Text(
        this.text,
        style: TextStyle(
          color: Colors.black38,
          fontSize: 40,
        ),
      ),
    );
  }
}
