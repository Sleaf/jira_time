import 'package:redux/redux.dart';

class User {
  final String name;
  final String email;

  const User(this.name, this.email);

  static const EMPTY = const User('', '');
}

final userReducer = combineReducers<User>([
  TypedReducer<User, RefreshUserDataAction>(_refresh),
]);

User _refresh(User user, action) {
  user = action.user;
  return user;
}

class RefreshUserDataAction {
  final User user;

  RefreshUserDataAction(this.user);
}
