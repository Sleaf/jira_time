/*
* Get error message from server response
* */
import 'package:dio/dio.dart';

String getServerErrorMsgHelper(DioError error) => error.response.data['errorMessages'].join(' ');

String getAvatarUrl(payload)=>payload['avatarUrls']['48x48'];