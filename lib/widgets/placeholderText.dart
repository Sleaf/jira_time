import 'package:flutter/material.dart';

class PlaceholderText extends StatelessWidget {
  final String text;
  final Matrix4 transform;

  const PlaceholderText(this.text, {this.transform});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      transform: this.transform,
      child: Text(
        this.text,
        style: Theme.of(context).textTheme.display2,
      ),
    );
  }
}
