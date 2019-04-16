// GENERATED CODE - DO NOT MODIFY BY HAND

part of env;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Env _$EnvFromJson(Map<String, dynamic> json) {
  return Env(
      baseUrl: json['baseUrl'] as String,
      savedUsername: json['savedUsername'] as String,
      savedPwd: json['savedPwd'] as String);
}

Map<String, dynamic> _$EnvToJson(Env instance) => <String, dynamic>{
      'baseUrl': instance.baseUrl,
      'savedUsername': instance.savedUsername,
      'savedPwd': instance.savedPwd
    };
