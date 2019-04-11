import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:jira_time/generated/i18n.dart';
import 'package:jira_time/redux/store.dart';
import 'package:jira_time/routes.dart';
import 'package:jira_time/redux/modules/user.dart';
import 'package:jira_time/constant/manifest.dart';
import 'package:jira_time/constant/themes.dart';

class Main extends StatelessWidget {
  final Store store;

  const Main({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: StoreBuilder<AppState>(builder: (context, store) {
        return MaterialApp(
          title: APP_NAME,
          theme: store.state.themeData,
          initialRoute: '/',
          routes: routes,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
        );
      }),
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

  final store = Store<AppState>(
    appReducer,
    initialState: initialState ??
        AppState(
          userInfo: User.EMPTY,
          themeData: Themes.DEFAULT,
          locale: const Locale('zh', 'CN'),
        ),
    middleware: [persistor.createMiddleware()],
  );
  runApp(Main(store: store));
}
