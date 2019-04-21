import 'dart:io';
import 'package:flutter/services.dart';

void displayStatusBar() {
  // 显示顶部状态栏
  if (Platform.isAndroid) {
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }
}

void hideStatusBar() {
  // 隐藏顶部状态栏
  if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }
}
