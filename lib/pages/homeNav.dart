import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jira_time/actions/actions.dart';
import 'package:jira_time/constant/themes.dart';
import 'package:jira_time/generated/i18n.dart';
import 'package:jira_time/pages/login.dart';
import 'package:jira_time/pages/settings.dart';
import 'package:jira_time/redux/modules/theme.dart';
import 'package:jira_time/util/redux.dart';
import 'package:jira_time/util/request.dart';

class HomeNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final reduxStore = getAppState(context);
    return Drawer(
      //侧边栏按钮Drawer
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            //Material内置控件
            accountName: Text(reduxStore.userInfo.displayName ?? ''),
            //用户名
            accountEmail: Text(reduxStore.userInfo.emailAddress ?? ''),
            //用户邮箱
            currentAccountPicture: GestureDetector(
              //用户头像
              onTap: () => print('todo to user settings'),
              child: reduxStore.userInfo.avatarUrls != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://jira.hypers.com/secure/useravatar?ownerId=shu.huang&avatarId=12103',
                        headers: {
                          'cookie': request.cookie,
                        },
                      ),
                    )
                  : Icon(
                      Icons.person,
                      color: Theme.of(context).textSelectionColor,
                    ),
            ),
            decoration: BoxDecoration(
              //用一个BoxDecoration装饰器提供背景图片
              color: Theme.of(context).primaryColor,
            ),
          ),
          Divider(),
          ListTile(
            title: Text(S.of(context).dark_mode),
            leading: Icon(Icons.brightness_2),
            trailing: Switch(
              value: getAppState(context).theme == Themes.DARK,
              onChanged: (bool isDarkMode) {
                dispatchAppAction(
                  context,
                  RefreshThemeDataAction(isDarkMode ? Themes.DARK : Themes.DEFAULT),
                );
              },
            ),
          ),
          ListTile(
            title: Text(S.of(context).settings),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Settings()));
            },
          ),
          ListTile(
            title: Text(S.of(context).logout),
            leading: Icon(Icons.directions_run),
            onTap: () {
              logout(context);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => route == null,
              );
            },
          ),
        ],
      ),
    );
  }
}
