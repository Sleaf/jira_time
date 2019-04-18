import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:jira_time/actions/actions.dart';
import 'package:jira_time/constant/themes.dart';
import 'package:jira_time/generated/i18n.dart';
import 'package:jira_time/pages/login.dart';
import 'package:jira_time/pages/settings.dart';
import 'package:jira_time/redux/modules/theme.dart';
import 'package:jira_time/util/redux.dart';
import 'package:jira_time/util/response.dart';
import 'package:jira_time/widgets/networkImageWithCookie.dart';

class HomeNav extends StatelessWidget {
  final List customFilter;
  final List projects;

  const HomeNav({Key key, this.projects, this.customFilter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reduxStore = getAppState(context);
    // add user info header
    final List<Widget> listItems = [
      UserAccountsDrawerHeader(
        //Material内置控件
        accountName: Text(reduxStore.userInfo.displayName ?? ''),
        //用户名
        accountEmail: Text(reduxStore.userInfo.emailAddress ?? ''),
        //用户邮箱
        currentAccountPicture: GestureDetector(
          //用户头像
          onTap: () => print('todo to user settings'),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).backgroundColor,
            backgroundImage: reduxStore.userInfo.avatarUrls != null
                ? NetworkImageWithCookie(reduxStore.userInfo.avatarUrls)
                : AssetImage('assets/images/useravatar_placeholder.png'),
          ),
        ),
        decoration: BoxDecoration(
          //用一个BoxDecoration装饰器提供背景图片
          color: Theme.of(context).primaryColor,
        ),
      ),
    ];
    // add fix filter
    listItems.addAll([
      ListTile(
        title: Text(S.of(context).my_unresolved_issue),
        leading: Icon(Icons.assignment),
        onTap: () {
          final jql = 'assignee = currentUser() AND resolution = Unresolved order by updated DESC';
        },
      ),
      ListTile(
        title: Text(S.of(context).my_report_issue),
        leading: Icon(Icons.bug_report),
        onTap: () {
          final jql = 'reporter = currentUser() order by created DESC';
        },
      ),
    ]);
    // add custom filters
    listItems.addAll(this.customFilter.map((filter) => ListTile(
        title: Text(filter['name']),
        leading: Icon(Icons.favorite),
        onTap: () {
          final jql = filter['jql'];
        })));
    // add projects
    listItems.add(Divider());
    listItems.addAll(this.projects.map((project) => ListTile(
          title: Text(project['name']),
          leading: SvgPicture.network(
            getAvatarUrl(project),
            width: 32,
          ),
          onTap: () {},
        )));
    listItems.add(Divider());
    // add settings
    listItems.addAll([
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
    ]);
    return Drawer(
      //侧边栏按钮Drawer
      child: ListView(
        children: listItems,
      ),
    );
  }
}
