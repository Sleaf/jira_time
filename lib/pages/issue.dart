import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jira_time/actions/api.dart';
import 'package:jira_time/generated/i18n.dart';
import 'package:jira_time/widgets/customSvg.dart';
import 'package:jira_time/widgets/customCard.dart';
import 'package:jira_time/widgets/endLine.dart';
import 'package:jira_time/widgets/loading.dart';
import 'package:jira_time/util/lodash.dart';
import 'package:jira_time/widgets/networkImageWithCookie.dart';
import 'package:jira_time/widgets/placeholderText.dart';
import 'package:jira_time/widgets/userDisplay.dart';

class Issue extends StatefulWidget {
  final String issueKey;

  const Issue(this.issueKey);

  @override
  _IssueState createState() => _IssueState(this.issueKey);
}

class _IssueState extends State<Issue> with SingleTickerProviderStateMixin {
  final String issueKey;
  Map<String, dynamic> _issueData;
  List _issueComments;
  List _issueWorkLogs;

  _IssueState(this.issueKey);

  @override
  void initState() {
    super.initState();
    // init issue data
    fetchIssue(this.issueKey).then((issueData) {
      setState(() {
        this._issueData = issueData;
      });
    });
    // fetch issue comments
    fetchIssueComments(this.issueKey).then((comments) {
      setState(() {
        this._issueComments = comments
          ..sort((a, b) {
            final DateTime aTime = DateTime.parse(a['updated']);
            final DateTime bTime = DateTime.parse(b['updated']);
            return bTime.compareTo(aTime);
          });
      });
    });
    // fetch issue work logs
    fetchIssueWorkLogs(this.issueKey).then((workLogs) {
      setState(() {
        this._issueWorkLogs = workLogs
          ..sort((a, b) {
            final DateTime aTime = DateTime.parse(a['started']);
            final DateTime bTime = DateTime.parse(b['started']);
            return bTime.compareTo(aTime);
          });
      });
    });
  }

  Widget buildContent(BuildContext context) {
    final payload = this._issueData['fields'];
    final double textHeight = 16.0;
    final listItems = <Widget>[
      Container(
        padding: EdgeInsets.all(5),
        child: Text(
          payload['summary'],
          style: Theme.of(context).textTheme.title,
        ),
      ),
      Divider(),
      ListTile(
        title: Text(
          S.of(context).status,
          style: Theme.of(context).textTheme.title,
        ),
        trailing: Wrap(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 2),
              height: textHeight,
              child: Image(image: NetworkImageWithCookie(payload['status']['iconUrl'])),
            ),
            Text(
              $_get(
                payload,
                ['status', 'name'],
                defaultData: S.of(context).unspecified,
              ),
            ),
          ],
        ),
      ),
      ListTile(
        title: Text(
          S.of(context).issue_type,
          style: Theme.of(context).textTheme.title,
        ),
        trailing: Wrap(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 2),
              height: textHeight,
              child: CustomSvg(
                $_get(payload, ['issuetype', 'iconUrl']),
                width: 16,
              ),
            ),
            Text(
              $_get(
                payload,
                ['issuetype', 'name'],
                defaultData: S.of(context).unspecified,
              ),
            ),
          ],
        ),
      ),
      ListTile(
        title: Text(
          S.of(context).priority,
          style: Theme.of(context).textTheme.title,
        ),
        trailing: Wrap(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 2),
              height: textHeight,
              child: CustomSvg(
                $_get(payload, ['priority', 'iconUrl']),
                width: 16,
              ),
            ),
            Text(
              $_get(
                payload,
                ['priority', 'name'],
                defaultData: S.of(context).unspecified,
              ),
            ),
          ],
        ),
      ),
      Divider(),
      ListTile(
        title: Text(
          S.of(context).reporter,
          style: Theme.of(context).textTheme.title,
        ),
        trailing: UserDisplay(payload['reporter']),
      ),
      ListTile(
        title: Text(
          S.of(context).assignee,
          style: Theme.of(context).textTheme.title,
        ),
        trailing: UserDisplay(payload['assignee']),
      ),
    ];
    // add description if exist
    if (payload['description'] != null) {
      listItems.add(LargeItem(
        S.of(context).description,
        child: Text(payload['description']),
      ));
    }
    // add comments
    listItems.add(LargeItem(
      S.of(context).comments,
      createIcon: Icons.add,
      onTapCreateIcon: () {
        Fluttertoast.showToast(msg: S.of(context).coming_soon);
      },
      child: this._issueComments != null
          ? this._issueComments.length > 0
              ? Column(
                  children: this._issueComments.map((commentData) {
                    return CustomCard(
                      header: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          UserDisplay(commentData['updateAuthor']),
                        ],
                      ),
                      body: Text(commentData['body']),
                      updatedTime: commentData['updated'],
                    );
                  }).toList(),
                )
              : PlaceholderText(S.of(context).no_data)
          : Loading(
              withoutContainer: true,
              backgroundColor: null,
            ),
    ));
    // add work logs
    listItems.add(LargeItem(
      S.of(context).work_logs,
      createIcon: Icons.add,
      onTapCreateIcon: () {
        Fluttertoast.showToast(msg: S.of(context).coming_soon);
      },
      child: this._issueWorkLogs != null
          ? this._issueWorkLogs.length > 0
              ? Column(
                  children: this._issueWorkLogs.map((workLogData) {
                    return CustomCard(
                      header: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          UserDisplay(workLogData['updateAuthor']),
                          Text(workLogData['timeSpent'], style: Theme.of(context).textTheme.title),
                        ],
                      ),
                      body: Text(workLogData['comment']),
                      updatedTime: workLogData['started'],
                    );
                  }).toList(),
                )
              : PlaceholderText(S.of(context).no_data)
          : Loading(
              withoutContainer: true,
              backgroundColor: null,
            ),
    ));
    listItems.add(EndLine(S.of(context).no_more_data));
    return Container(
      padding: EdgeInsets.all(5),
      child: ListView(
        children: listItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.issueKey),
      ),
      body: this._issueData != null ? this.buildContent(context) : Loading(),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {},
//        tooltip: S.of(context).new_work_log,
//        child: Icon(Icons.edit),
//      ),
    );
  }
}

class LargeItem extends StatelessWidget {
  final String title;
  final IconData createIcon;
  final Function onTapCreateIcon;

  final Widget child;

  const LargeItem(this.title, {Key key, this.child, this.createIcon, this.onTapCreateIcon})
      : super(key: key);

  Widget buildTitle(BuildContext context) {
    final List<Widget> titleItems = [
      Text(this.title, style: Theme.of(context).textTheme.title),
    ];
    if (this.createIcon != null) {
      titleItems.add(
        GestureDetector(
            onTap: this.onTapCreateIcon,
            child: Opacity(
              opacity: 0.66,
              child: Wrap(
                children: <Widget>[
                  Icon(this.createIcon),
                  Text(S.of(context).newOne),
                ],
              ),
            )),
      );
//      titleItems.add(
//        FloatingActionButton.extended(
//          onPressed: this.onTapCreateIcon,
//          icon: Icon(this.createIcon),
//          label: Text(S.of(context).newOne),
//        ),
//      );
    }
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        mainAxisAlignment:
            this.createIcon == null ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
        children: titleItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(),
          buildTitle(context),
          this.child,
        ],
      ),
    );
  }
}
