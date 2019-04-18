import 'dart:convert';

import 'package:jira_time/constant/API.dart';
import 'package:jira_time/util/request.dart';

/*
* 从服务器获取 session 信息
* */
Future fetchSession(String username, String password) async {
  final response = await request.post(
    API_AUTH_SESSION,
    data: {
      'username': username,
      'password': password,
    },
  );
  return response.data;
}

/*
* 从服务器删除 session 信息
* */
Future deleteSession() async {
  final response = await request.delete(API_AUTH_SESSION);
  return response.data;
}

/*
* 获取可创建的 project / meta
* */
Future fetchIssueMeta() async {
  final response = await request.get(API_ISSUE_METAS);
  return response.data['projects'];
}

/*
* 创建 issue
* */
Future createIssue(
  String projectId,
  String issueTypeId,
  String summary, {
  String assignee,
}) async {
  final response = await request.post(
    API_ISSUE,
    data: {
      'fields': {
        'project': {'id': projectId},
        'issuetype': {'id': issueTypeId},
        'summary': summary,
        'assignee': {'name': assignee},
      }
    },
  );
  return response.data;
}

/*
* 获取 issue 列表
* */
Future fetchIssueList({
  String jql,
  String projectName,
  List<String> statusIds,
  int startAt,
  int maxResults,
}) async {
  var response = await request.get(API_SEARCH, queryParameters: {
    'jql': jql ?? "'project = '${projectName}' and status in (${statusIds.join(',')})",
    'startAt': startAt,
    'maxResults': maxResults,
  });
  return response.data['issues'];
}

/*
* 从服务器获取 用户信息
* */
Future fetchUserInfo(String username) async {
  final response = await request.get(
    API_USER,
    queryParameters: {
      'username': username,
    },
  );
  return response.data;
}

/*
* 从服务器获取 有权限的所有项目
* */
Future fetchAllProjects() async {
  final response = await request.get(API_PROJECT);
  return response.data;
}

/*
* 从服务器获取 有权限的所有项目
* */
Future fetchFavouriteFilter() async {
  final response = await request.get(API_FAVOURITE_FILTER);
  return response.data;
}
