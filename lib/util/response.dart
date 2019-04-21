/*
* Get error message from server response
* */
import 'package:dio/dio.dart';

String getServerErrorMsgHelper(DioError error) => error.response.data['errorMessages'].join(' ');

String getAvatarUrl(payload, {int size: 48}) =>
    payload != null ? payload['avatarUrls']['${size}x${size}'] : null;
