import 'package:flutter/material.dart';
import 'package:jira_time/constant/locales.dart';
import 'package:jira_time/generated/i18n.dart';
import 'package:jira_time/redux/modules/locale.dart';
import 'package:jira_time/util/redux.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
      ),
      body: ListView(
        children: <Widget>[
          SettingRow(
            child: SettingText(S.of(context).language),
            leading: Icon(Icons.language),
            trailing: Text(LocaleNameMap[getAppState(context).locale]),
            onTap: () {
              showDialog(
                context: context, //BuildContext对象
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return LanguageDialog(
                    //调用对话框
                    value: '正在获取详情...',
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class SettingRow extends StatelessWidget {
  final Widget child;
  final Widget leading;
  final Widget trailing;
  final GestureTapCallback onTap;

  SettingRow({this.child, this.leading, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: const Border(
          bottom: const BorderSide(
            color: Colors.black12,
            width: 1.0,
          ),
        ),
      ),
      child: ListTile(
        leading: this.leading,
        trailing: Container(
          margin: EdgeInsets.only(right: 20),
          child: this.trailing,
        ),
        onTap: this.onTap,
        title: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: child,
        ),
      ),
    );
  }
}

class SettingText extends StatelessWidget {
  final String _text;

  SettingText(this._text);

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style:Theme.of(context).textTheme.title,
    );
  }
}

class LanguageDialog extends Dialog {
  final String value;
  final Function onChanged;

  LanguageDialog({Key key, this.value, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Material(
        //创建透明层
        type: MaterialType.transparency, //透明类型
        child: Center(
          //保证控件居中效果
          child: Container(
            width: 220.0,
            height: 70.0 * LocaleNameMap.length,
            decoration: ShapeDecoration(
              color: Theme.of(context).backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(2.0),
                ),
              ),
            ),
            child: ListView(
              children: LocaleNameMap.entries.map((MapEntry<Locales, String> locale) {
                return ListTile(
                  title: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Text(locale.value),
                  ),
                  onTap: () {
                    dispatchAppAction(context, RefreshLocaleDataAction(locale.key));
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
