import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final Color backgroundColor;
  final bool withoutContainer;

  const Loading({Key key, this.backgroundColor: Colors.black12, this.withoutContainer: false})
      : super(key: key);

  Widget buildContent(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return this.withoutContainer
        ? buildContent(context)
        : Container(
            constraints: BoxConstraints.expand(),
            color: backgroundColor,
            child: buildContent(context),
          );
  }
}
