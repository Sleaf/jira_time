import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jira_time/redux/store.dart';

AppState getAppState(BuildContext context) => StoreProvider.of<AppState>(context).state;

void dispatchAppAction(BuildContext context, dynamic action) =>
    StoreProvider.of<AppState>(context).dispatch(action);
