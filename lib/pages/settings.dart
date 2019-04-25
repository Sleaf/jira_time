import 'package:flutter/material.dart';
import 'package:jira_time/constant/locales.dart';
import 'package:jira_time/generated/i18n.dart';
import 'package:jira_time/redux/modules/locale.dart';
import 'package:jira_time/util/customDialog.dart';
import 'package:jira_time/util/redux.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Locales locale = getAppState(context).locale;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
      ),
      body: ListView(
        children: <Widget>[
          SettingRow(
            child: SettingText(S.of(context).language),
            leading: Icon(Icons.language),
            trailing: Text(
                locale == Locales.followSystem ? S.of(context).follow_system : S.of(context).$),
            onTap: () {
              showCustomDialog(
                context: context, //BuildContext对象
                child: Container(
                  decoration: ShapeDecoration(
                    color: Theme.of(context).backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(3.0),
                      ),
                    ),
                  ),
                  child: Wrap(
                    direction: Axis.vertical,
                    children: Locales.values.map((Locales locale) {
                      return GestureDetector(
                        child: Container(
                          width: 200,
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                          child: Text(
                            locale == Locales.followSystem
                                ? S.of(context).follow_system
                                : LocaleNameMap[locale],
                            style: Theme.of(context).textTheme.subhead,
                          ),
                        ),
                        onTap: () {
                          dispatchAppAction(context, RefreshLocaleDataAction(locale));
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ),
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
      style: Theme.of(context).textTheme.title,
    );
  }
}
