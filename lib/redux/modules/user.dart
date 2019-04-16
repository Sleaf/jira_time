library user;

import 'package:json_annotation/json_annotation.dart';
import 'package:redux/redux.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  final String name;
  final String displayName;
  final String emailAddress;
  final String avatarUrls;

  const User({this.name, this.displayName, this.emailAddress, this.avatarUrls});

  static const EMPTY = const User();
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
