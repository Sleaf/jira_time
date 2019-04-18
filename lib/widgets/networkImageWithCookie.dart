import 'package:flutter/material.dart';
import 'package:jira_time/util/request.dart';

class NetworkImageWithCookie extends NetworkImage {
  final String url;

  NetworkImageWithCookie(this.url)
      : super(url, headers: {
          'cookie': request.cookie,
        });
}
