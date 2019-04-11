import 'package:redux/redux.dart';

class Env {
  final String baseUrl;

  const Env(this.baseUrl);
}

final envReducer = combineReducers<Env>([
  TypedReducer<Env, RefreshEnvDataAction>(_refresh),
]);

Env _refresh(Env env, action) {
  env = action.env;
  return env;
}

class RefreshEnvDataAction {
  final Env env;

  RefreshEnvDataAction(this.env);
}
