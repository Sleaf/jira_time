import 'package:jira_time/constant/themes.dart';
import 'package:redux/redux.dart';

///通过 flutter_redux 的 combineReducers，创建 Reducer<State>
final themeDataReducer = combineReducers<Themes>([
  ///将Action，处理Action动作的方法，State绑定
  TypedReducer<Themes, RefreshThemeDataAction>(_refresh),
]);

///定义处理 Action 行为的方法，返回新的 State
Themes _refresh(Themes theme, action) {
  theme = action.theme;
  return theme;
}

///定义一个 Action 类
///将该 Action 在 Reducer 中与处理该Action的方法绑定
class RefreshThemeDataAction {
  final Themes theme;

  RefreshThemeDataAction(this.theme);
}
