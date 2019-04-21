import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:jira_time/constant/themes.dart';
import 'package:jira_time/constant/locales.dart';
import 'package:jira_time/redux/modules/user.dart';
import 'package:jira_time/redux/modules/theme.dart';
import 'package:jira_time/redux/modules/environment.dart';
import 'package:jira_time/redux/modules/locale.dart';

@JsonSerializable()
class AppState {
  //环境信息
  Env env;

  //用户信息
  User userInfo;

  //主题
  Themes theme;

  //语言
  Locales locale;

  //构造方法
  AppState({
    this.env,
    this.userInfo,
    this.theme,
    this.locale,
  });

  static final DEFAULT = AppState(
    env: Env.EMPTY,
    userInfo: User.EMPTY,
    theme: Themes.DEFAULT,
    locale: Locales.followSystem,
  );

  static AppState fromJson(store) => store != null
      ? AppState(
          env: Env.fromJson(jsonDecode(store['env'])),
          userInfo: User.fromJson(jsonDecode(store['userInfo'])),
          theme: getThemesFromString(store['theme']),
          locale: getLocalesFromString(store['locale']),
        )
      : AppState.DEFAULT;

  // 更新状态之后，转成 JSON，然后持久化至持久化引擎中
  Map<String, dynamic> toJson() => {
        'env': jsonEncode(env),
        'userInfo': jsonEncode(userInfo),
        'theme': theme.toString(),
        'locale': locale.toString(),
      };
}

AppState appReducer(AppState state, action) {
  return AppState(
    //通过自定义 envReducer 将 AppState 内的 env 和 action 关联在一起
    env: envReducer(state.env, action),

    //通过自定义 UserReducer 将 AppState 内的 userInfo 和 action 关联在一起
    userInfo: userReducer(state.userInfo, action),

    //通过自定义 ThemeDataReducer 将 AppState 内的 theme 和 action 关联在一起
    theme: themeDataReducer(state.theme, action),

    //通过自定义 LocaleReducer 将 AppState 内的 locale 和 action 关联在一起
    locale: localeReducer(state.locale, action),
  );
}
