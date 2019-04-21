import 'package:flutter/material.dart';

class EndLine extends StatelessWidget {
  final String text;

  const EndLine(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Divider()),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text(
            this.text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.display1,
          ),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}
