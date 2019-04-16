// GENERATED CODE - DO NOT MODIFY BY HAND

part of user;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      emailAddress: json['emailAddress'] as String,
      avatarUrls: json['avatarUrls'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'displayName': instance.displayName,
      'emailAddress': instance.emailAddress,
      'avatarUrls': instance.avatarUrls
    };
