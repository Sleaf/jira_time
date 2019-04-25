import 'package:flutter/material.dart';

showCustomDialog({
  @required BuildContext context,
  @required Widget child,
  bool barrierDismissible: true, // 点击外部是否隐藏对话框
}) async {
  showDialog(
    context: context, //BuildContext对象
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      final List<Widget> buildWidgets = [
        child,
      ];
      if (!barrierDismissible) {
        // 右上角添加退出按钮
        buildWidgets.add(GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.close,
              size: 24,
            ),
          ),
        ));
      }
      return GestureDetector(
        onTap: () => barrierDismissible ? Navigator.pop(context) : null,
        child: Material(
          //创建透明层
          type: MaterialType.transparency, //透明类型
          child: Center(
            //保证控件居中效果
            child: GestureDetector(
              onTap: () {}, // 防止被弹出
              child: Stack(
                alignment: Alignment.topRight,
                children: buildWidgets,
              ),
            ),
          ),
        ),
      );
    },
  );
}
