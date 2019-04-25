import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/*
* 解析 如 5w1h4m 类型的工时时间
* 支持 w d h m
* 1w = 5d 1d = 8h 1h = 60m
* 返回 等价秒数 / null
* */
int parseWorkLogStr(String workLogStr) {
  final RegExp workTimeRegRule = RegExp(r'([0-9.]+)([wdhm])', caseSensitive: false);
  final RegExp allDigital = RegExp(r'^\d+$');
  if (allDigital.hasMatch(workLogStr)) {
    // 默认全数字则为小时
    return int.parse(workLogStr) * 3600;
  }
  workLogStr = workLogStr.replaceAll('\b', '');
  Iterable<Match> matches = workTimeRegRule.allMatches(workLogStr);
  if (matches.length > 0) {
    int acc = 0;
    for (Match match in matches) {
      int factor = 0;
      switch (match[2]) {
        case 'w':
          factor = 5 * 8 * 60 * 60;
          break;
        case 'd':
          factor = 8 * 60 * 60;
          break;
        case 'h':
          factor = 60 * 60;
          break;
        case 'm':
          factor = 60;
          break;
      }
      acc += int.parse(match[1]) * factor;
    }
    return acc;
  } else {
    return null;
  }
}

/*
* 输出根据 Locale 格式化之后的时间
* */
String formatDateTimeString({
  DateTime date,
  String dateString,
  @required BuildContext context,
  bool HHmm: false,
}) {
  assert(date != null || dateString != null && dateString.length >= 20,
      'date must not be null, or has a legal dateString.');
  DateTime time = date ?? DateTime.parse(dateString.substring(0, 19));
  String localeStr = Localizations.localeOf(context).toString();
  String dateStr = DateFormat.yMMMd(localeStr).format(time);
  String timeStr = DateFormat.Hm(localeStr).format(time);
  return HHmm ? '$dateStr  $timeStr' : dateStr;
}
