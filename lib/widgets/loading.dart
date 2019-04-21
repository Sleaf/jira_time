import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final Color backgroundColor;

  const Loading({Key key, this.backgroundColor: Colors.black12}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      color: backgroundColor,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
