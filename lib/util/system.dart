import 'package:flutter/services.dart';

void displayStatusBar() {
  // 显示顶部状态栏
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
}

void hideStatusBar() {
  // 隐藏顶部状态栏
  SystemChrome.setEnabledSystemUIOverlays([]);
}
