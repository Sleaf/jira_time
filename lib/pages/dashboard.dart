import 'package:flutter/material.dart';
import 'package:jira_time/actions/actions.dart';
import 'package:jira_time/generated/i18n.dart';
import 'package:jira_time/util/system.dart';
import 'package:jira_time/pages/homeNav.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    displayStatusBar();
    fetchSelf(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).dashboard),
      ),
      drawer: HomeNav(),
      body: Text('hello'),
    );
  }
}
