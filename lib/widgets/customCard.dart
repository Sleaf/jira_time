import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jira_time/util/string.dart';

class CustomCard extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Widget foot;
  final String createdTime;
  final String updatedTime;
  final bool showHHmm;

  const CustomCard({
    Key key,
    this.header,
    @required this.body,
    this.foot,
    this.createdTime,
    this.updatedTime,
    this.showHHmm: false,
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
        Text(formatDateTimeString(
          dateString: this.updatedTime,
          context: context,
          HHmm: this.showHHmm,
        )),
      ];
      if (this.createdTime != null) {
        footItems.insertAll(0, [
          Text(formatDateTimeString(
            dateString: this.createdTime,
            context: context,
            HHmm: this.showHHmm,
          )),
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
