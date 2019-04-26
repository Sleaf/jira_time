import 'package:flutter/material.dart';
import 'package:jira_time/constant/API.dart';
import 'package:jira_time/util/request.dart';

/*
* 从服务器获取 session 信息
* */
Future<Map> fetchSession(String username, String password) async {
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
Future<List> fetchIssueMeta() async {
  final response = await request.get(API_ISSUE_METAS);
  return response.data['projects'];
}

/*
* 创建 issue
* */
Future<Map> createIssue(
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
* 获取 issue详情
* */
Future<Map> fetchIssue(String key) async {
  final response = await request.get('$API_ISSUE/$key');
  return response.data;
}

/*
* 获取 issue comment
* */
Future<List> fetchIssueComments(String key) async {
  final response = await request.get('$API_ISSUE/$key/comment');
  return response.data['comments'];
}

/*
* 新增 issue comment
* */
Future addIssueComments(String key, String body) async {
  final response = await request.post('$API_ISSUE/$key/comment', data: {
    'body': body,
  });
  return response.data;
}

/*
* 获取 issue work logs
* */
Future<List> fetchIssueWorkLogs(String key) async {
  final response = await request.get('$API_ISSUE/$key/worklog');
  return response.data['worklogs'];
}

/*
* 获取 issue work logs
* */
Future<List> fetchIssueAttachments(String key) async {
  final response = await request.get('$API_ISSUE/$key/attachments');
  return response.data;
}

/*
* 新增 issue work logs
* */
Future<List> addIssueWorkLogs(
  String key, {
  @required String workLogComment,
  @required DateTime started,
  @required int timeSpentSeconds,
}) async {
  final response = await request.post('$API_ISSUE/$key/worklog', data: {
    'comment': workLogComment,
    'started': started.toIso8601String().substring(0, 22) + '+0800',
    'timeSpentSeconds': timeSpentSeconds,
  });
  return response.data['worklogs'];
}

/*
* 获取 issue 列表
* */
Future<List> fetchIssueList({
  String jql,
  String projectKey,
  int startAt,
  int maxResults,
}) async {
  var response = await request.post(API_SEARCH, data: {
    'jql': jql ?? 'project = "$projectKey" order by updated DESC',
    'startAt': startAt,
    'maxResults': maxResults,
  });
  return response.data['issues'];
}

/*
* 从服务器获取 用户信息
* */
Future<Map> fetchUserInfo(String username) async {
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
Future<List> fetchAllProjects() async {
  final response = await request.get(API_PROJECT);
  return response.data;
}

/*
* 从服务器获取 收藏的过滤器
* */
Future<List> fetchFavouriteFilter() async {
  final response = await request.get(API_FAVOURITE_FILTER);
  return response.data;
}

/*
* 从服务器获取 所有 status category
* */
Future<List> fetchAllStatusCategories() async {
  final response = await request.get(API_STATUS_CATEGORY);
  return (response.data as List).where((item) => item['key'] != 'undefined').toList();
}

/*
* 从服务器获取 所有 status
* */
Future<List> fetchAllStatus() async {
  final response = await request.get(API_STATUS);
  return response.data;
}
