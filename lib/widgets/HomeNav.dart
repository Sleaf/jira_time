import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jira_time/constant/themes.dart';
import 'package:jira_time/redux/modules/theme.dart';
import 'package:jira_time/redux/store.dart';
import 'package:jira_time/util/notification.dart';

class HomeNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      //侧边栏按钮Drawer
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            //Material内置控件
            accountName: Text('Sleaf'),
            //用户名
            accountEmail: Text('shu.huang@mail.hypers.com'),
            //用户邮箱
            currentAccountPicture: GestureDetector(
              //用户头像
              onTap: () => print('current user'),
              child: CircleAvatar(
                //圆形图标控件
                backgroundImage: NetworkImage(
                    'https://avatars1.githubusercontent.com/u/23637144?s=460&v=4'), //图片调取自网络
              ),
            ),
            decoration: BoxDecoration(
              //用一个BoxDecoration装饰器提供背景图片
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            title: Text('Switch Theme'),
            trailing: Icon(Icons.cached),
            onTap: () {
              final curTheme =
                  StoreProvider.of<AppState>(context).state.themeData;
              final action = RefreshThemeDataAction(
                  curTheme == Themes.DARK ? Themes.DEFAULT : Themes.DARK);
              StoreProvider.of<AppState>(context).dispatch(action);
            },
          ),
          ListTile(
            title: Text('Display Notification'),
            trailing: Icon(Icons.notifications),
            onTap: () {
              final notification = LocalNotification()..display();
            },
          ),
        ],
      ),
    );
  }
}
