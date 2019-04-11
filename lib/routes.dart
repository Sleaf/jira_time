import 'package:flutter/material.dart';
import 'package:jira_time/pages/dashboard.dart';
import 'package:jira_time/pages/login.dart';
import 'package:jira_time/pages/issue.dart';
import 'package:jira_time/pages/filter.dart';
import 'package:jira_time/constant/manifest.dart';

final routes = <String, WidgetBuilder>{
  // 登录
  '/': (BuildContext context) => Login(),
  // 仪表盘
  '/secure/Dashboard': (BuildContext context) => Dashboard(title: APP_NAME),
  // 问题详情页
  '/browse': (BuildContext context) => Issue(),
  // 项目详情
  '/secure/BrowseProjects': (BuildContext context) => Filter(),
};

