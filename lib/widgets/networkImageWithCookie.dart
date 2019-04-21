import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:jira_time/util/request.dart';

class NetworkImageWithCookie extends AdvancedNetworkImage {
  final String url;

  NetworkImageWithCookie(this.url)
      : super(
          url,
          header: {
            'cookie': request.cookie,
          },
          useDiskCache: true,
        );
}
