library env;

import 'package:json_annotation/json_annotation.dart';
import 'package:redux/redux.dart';

part 'environment.g.dart';

@JsonSerializable()
class Env {
  factory Env.fromJson(Map<String, dynamic> json) => _$EnvFromJson(json);

  Map<String, dynamic> toJson() => _$EnvToJson(this);

  final String baseUrl;
  final String savedUsername;
  final String savedPwd;

  const Env({
    this.baseUrl,
    this.savedUsername,
    this.savedPwd,
  });

  static const EMPTY = const Env();

  Env clearPwd() => Env(
        baseUrl: this.baseUrl,
        savedUsername: this.savedUsername,
      );
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
