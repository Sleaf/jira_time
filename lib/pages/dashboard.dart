import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jira_time/actions/actions.dart';
import 'package:jira_time/actions/api.dart';
import 'package:jira_time/generated/i18n.dart';
import 'package:jira_time/pages/newIssue.dart';
import 'package:jira_time/util/system.dart';
import 'package:jira_time/pages/homeNav.dart';
import 'package:jira_time/widgets/loading.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List _projects = [];
  List _customFilter = [];
  bool _doubleClickToExit = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    displayStatusBar();
    Future.wait([
      // fet my info
      fetchSelf(context),
      // fetch my projects
      fetchAllProjects(),
      // fetch custom filter
      fetchFavouriteFilter(),
    ]).then((List payloads) {
      final self = payloads[0];
      final projects = payloads[1];
      final filters = payloads[2];
      setState(() {
        this._projects = projects;
        this._customFilter = filters;
        this._loaded = true;
      });
    }, onError: (e) {
      print(e);
    });
  }

  handleChangeStatusView(value) {}

  Widget buildMainContent(BuildContext context) {
    return Text('hello');
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton(items: [], onChanged: this.handleChangeStatusView),
      ),
      drawer: HomeNav(
        customFilter: this._customFilter,
        projects: this._projects,
      ),
      body: _loaded ? buildMainContent(context) : Loading(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewIssue(),
            ),
          );
        },
        tooltip: S.of(context).newIssue,
        child: new Icon(Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: buildScaffold(context),
      onWillPop: () {
        if (Navigator.of(context).canPop() || _doubleClickToExit) {
          return Future.value(true);
        } else {
          Fluttertoast.showToast(msg: S.of(context).double_click_to_exit);
          _doubleClickToExit = true;
          Timer(
            const Duration(milliseconds: 500),
            () {
              _doubleClickToExit = false;
            },
          );
        }
      },
    );
  }
}

class Filter {
  final String name;
  final String Jql;

  Filter(this.name, this.Jql);
}
