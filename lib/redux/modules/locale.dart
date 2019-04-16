import 'package:jira_time/constant/locales.dart';
import 'package:redux/redux.dart';

final localeReducer = combineReducers<Locales>([
  TypedReducer<Locales, RefreshLocaleDataAction>(_refresh),
]);

Locales _refresh(Locales locale, action) {
  locale = action.locale;
  return locale;
}

class RefreshLocaleDataAction {
  final Locales locale;
  RefreshLocaleDataAction(this.locale);
}
