import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCard extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Widget foot;
  final String createdTime;
  final String updatedTime;

  const CustomCard({
    Key key,
    this.header,
    @required this.body,
    this.foot,
    this.createdTime,
    this.updatedTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> colItems = [];
    // add header
    if (this.header != null) {
      colItems.add(this.header);
      colItems.add(Divider());
    }
    //add body
    colItems.add(this.body);
    //add foot
    if (this.foot != null) {
      colItems.add(this.foot);
    } else if (this.updatedTime != null) {
      final footItems = <Widget>[
        Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(this.updatedTime))),
      ];
      if (this.createdTime != null) {
        footItems.insertAll(0, [
          Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(this.createdTime))),
          Icon(Icons.arrow_right, color: Theme.of(context).dividerColor),
        ]);
      }
      colItems.add(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: footItems,
      ));
    }

    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: colItems,
        ),
      ),
    );
  }
}
