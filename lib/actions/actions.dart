import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jira_time/actions/api.dart';
import 'package:jira_time/redux/modules/environment.dart';
import 'package:jira_time/generated/i18n.dart';
import 'package:jira_time/util/redux.dart';
import 'package:jira_time/util/request.dart';
import 'package:jira_time/constant/API.dart';
import 'package:jira_time/redux/modules/user.dart';
import 'package:jira_time/util/response.dart';

/*
* 从服务器获取个人信息
* */
Future fetchSelf(BuildContext context) async {
  final response = await request.get(API_MYSELF);
  final payload = response.data;
  // 存入 redux
  dispatchAppAction(
      context,
      RefreshUserDataAction(User(
        name: payload['name'],
        displayName: payload['displayName'],
        emailAddress: payload['emailAddress'],
        avatarUrls: getAvatarUrl(payload),
      )));
  return payload;
}

/*
* 获取登录信息
* 如果登录成功则返回 null
* 失败则返回提示信息
* */
Future login(BuildContext context, String hostname, String username, String password) async {
  // update request baseUrl
  request.updateBaseUrl(hostname);
  // start fetch
  Map<String, dynamic> payload;
  try {
    payload = await fetchSession(username, password);
    // deal with payload
  } catch (error) {
    // catch error messages
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.RESPONSE:
          return getServerErrorMsgHelper(error);
        case DioErrorType.RECEIVE_TIMEOUT:
        case DioErrorType.SEND_TIMEOUT:
          return S.of(context).error_server_timeout;
        default:
      }
    }
    return S.of(context).error_fetch_session;
  }
  // 存入 redux
  final session = payload['session'];
  if (session != null) {
    dispatchAppAction(
        context,
        RefreshEnvDataAction(Env(
          baseUrl: hostname,
          savedUsername: username,
          savedPwd: password,
        )));
    // 流程顺利则返回null
    return null;
  }
  return S.of(context).error_fetch_session;
}

/*
* 登出当前账户
* */
Future logout(BuildContext context) async {
  final curEnv = getAppState(context).env;
  deleteSession();
  dispatchAppAction(context, RefreshEnvDataAction(curEnv.clearPwd()));
  dispatchAppAction(context, RefreshUserDataAction(User.EMPTY));
}
