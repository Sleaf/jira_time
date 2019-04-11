import 'package:dio/dio.dart';
import 'package:jira_time/constant/API.dart';
import 'dart:async';

final dioConfig = BaseOptions(
//    connectTimeout: 5000,
//    receiveTimeout: 3000
    );

// 或者通过传递一个 `options`来创建dio实例
Dio request = new Dio();
