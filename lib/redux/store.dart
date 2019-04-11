import 'package:flutter/material.dart';
import 'package:jira_time/redux/modules/user.dart';
import 'package:jira_time/redux/modules/theme.dart';
import 'package:jira_time/redux/modules/environment.dart';
import 'package:jira_time/redux/modules/locale.dart';

class AppState {
  ///用户信息
  Env env;

  ///用户信息
  User userInfo;

  ///主题
  ThemeData themeData;

  ///语言
  Locale locale;

  ///构造方法
  AppState({this.env, this.userInfo, this.themeData, this.locale});

  // 持久化时，从 JSON 中初始化新的状态
  static AppState fromJson(store) => store != null
      ? AppState(
          env: store['env'],
          userInfo: store['userInfo'],
          themeData: store['themeData'],
          locale: store['locale'],
        )
      : AppState();

  // 更新状态之后，转成 JSON，然后持久化至持久化引擎中
  toJson() => {
        env: env,
        userInfo: userInfo,
        themeData: themeData,
        locale: locale,
      };
}

AppState appReducer(AppState state, action) {
  return AppState(
    ///通过自定义 envReducer 将 GSYState 内的 env 和 action 关联在一起
    env: envReducer(state.env, action),

    ///通过自定义 UserReducer 将 GSYState 内的 userInfo 和 action 关联在一起
    userInfo: userReducer(state.userInfo, action),

    ///通过自定义 ThemeDataReducer 将 GSYState 内的 themeData 和 action 关联在一起
    themeData: themeDataReducer(state.themeData, action),

    ///通过自定义 LocaleReducer 将 GSYState 内的 locale 和 action 关联在一起
    locale: localeReducer(state.locale, action),
  );
}
