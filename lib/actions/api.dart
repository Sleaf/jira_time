import 'package:jira_time/constant/API.dart';
import 'package:jira_time/util/request.dart';

/*
* 从服务器获取 session 信息
* */
fetchSession(String username, String password) async {
  final response = await request.post(API_AUTH_SESSION, data: {
    'username': username,
    'password': password,
  });
  return response.data;
}

/*
* 从服务器删除 session 信息
* */
deleteSession() async {
  final response = await request.delete(API_AUTH_SESSION);
  return response.data;
}
