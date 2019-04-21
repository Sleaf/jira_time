import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jira_time/actions/api.dart';
import 'package:jira_time/pages/dashboard.dart';
import 'package:jira_time/pages/login.dart';
import 'package:jira_time/redux/modules/user.dart';
import 'package:jira_time/util/request.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:jira_time/generated/i18n.dart';
import 'package:jira_time/redux/store.dart';
import 'package:jira_time/constant/manifest.dart';
import 'package:jira_time/constant/themes.dart';
import 'package:jira_time/constant/locales.dart';

class Main extends StatelessWidget {
  final Store store;
  final Widget homePage;

  const Main({Key key, this.store, this.homePage}) : super(key: key);
  static Store<AppState> globalStore;

  @override
  Widget build(BuildContext context) {
    // update store
    Main.globalStore = store;
    return StoreProvider<AppState>(
      store: store,
      child: StoreBuilder<AppState>(
        builder: (context, store) {
          return MaterialApp(
            title: APP_NAME,
            home: homePage,
            theme: ThemeDataMap[store.state.theme],
            locale: LocaleMap[store.state.locale] ?? MaterialLocalizations.of(context),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
          );
        },
      ),
    );
  }
}

void main() async {
  // 创建一个持久化器
  var persistor = Persistor<AppState>(
    storage: FlutterStorage(),
    serializer: JsonSerializer<AppState>(AppState.fromJson),
//    debug: true,
  );

  // 从 persistor 中加载上一次存储的状态
  final initialState = await persistor.load();

  //创建当前 store
  final store = Store<AppState>(
    appReducer,
    initialState: initialState,
    middleware: [persistor.createMiddleware()],
  );

  bool autoAuth = false;
  // update baseUrl
  if (store.state.env.baseUrl != null) {
    request.updateBaseUrl(store.state.env.baseUrl);
    // auto login
    if (store.state.userInfo != null && store.state.userInfo != User.EMPTY) {
      autoAuth = true;
      try {
        await fetchSession(
          store.state.env.savedUsername,
          store.state.env.savedPwd,
        );
      } catch (e) {
        autoAuth = false;
      }
    }
  }

  runApp(Main(
    store: store,
    homePage: autoAuth ? Dashboard() : Login(),
  ));
}

// get state from main
get stateFromMain {
  return Main.globalStore.state;
}
