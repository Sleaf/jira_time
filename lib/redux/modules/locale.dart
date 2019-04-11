import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

final localeReducer = combineReducers<Locale>([
  TypedReducer<Locale, RefreshLocaleDataAction>(_refresh),
]);

Locale _refresh(Locale locale, action) {
  locale = action.locale;
  return locale;
}

class RefreshLocaleDataAction {
  final Locale locale;
  RefreshLocaleDataAction(this.locale);
}
