import 'package:flutter/material.dart';
import 'package:jira_time/constant/locales.dart';
import 'package:jira_time/generated/i18n.dart';
import 'package:jira_time/redux/modules/locale.dart';
import 'package:jira_time/util/redux.dart';
import 'package:flutter_picker/flutter_picker.dart';

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
              final pickerDataList = LocaleNameMap.entries
                  .map((MapEntry locale) => PickerItem<Locales>(
                        text: Text(locale.value),
                        value: locale.key,
                      ))
                  .toList();
              Picker(
                hideHeader: true,
                adapter: PickerDataAdapter<Locales>(
                  data: pickerDataList,
                ),
                onConfirm: (Picker picker, List value) {
                  dispatchAppAction(
                      context, RefreshLocaleDataAction(picker.getSelectedValues()[0]));
                },
              )..showDialog(context);
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
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
