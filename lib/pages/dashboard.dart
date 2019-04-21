import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jira_time/actions/actions.dart';
import 'package:jira_time/actions/api.dart';
import 'package:jira_time/constant/jqls.dart';
import 'package:jira_time/constant/themes.dart';
import 'package:jira_time/generated/i18n.dart';
import 'package:jira_time/pages/issue.dart';
import 'package:jira_time/pages/login.dart';
import 'package:jira_time/pages/newIssue.dart';
import 'package:jira_time/pages/settings.dart';
import 'package:jira_time/redux/modules/theme.dart';
import 'package:jira_time/util/lodash.dart';
import 'package:jira_time/util/redux.dart';
import 'package:jira_time/util/response.dart';
import 'package:jira_time/util/system.dart';
import 'package:jira_time/widgets/customSvg.dart';
import 'package:jira_time/widgets/customAvatar.dart';
import 'package:jira_time/widgets/customCard.dart';
import 'package:jira_time/widgets/endLine.dart';
import 'package:jira_time/widgets/loading.dart';
import 'package:jira_time/widgets/placeholderText.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  TabController _tabController = TabController(vsync: null, length: 0);
  String _appBarTitle;

  List _customFilter = [];
  List _projects = [];
  List _stateCategories = [];
  List _issues = [];
  bool _doubleClickToExit = false;
  bool _loaded = false;
  bool _fetching = false;

  @override
  void initState() {
    super.initState();
    displayStatusBar();
    initData(context);
  }

  void initData(BuildContext context) {
    Future.wait([
      //[0] fet my info
      fetchSelf(context),
      //[1] fetch my projects
      fetchAllProjects(),
      //[2] fetch custom filter
      fetchFavouriteFilter(),
      //[3] fetch all status categories
      fetchAllStatusCategories(),
    ]).then((List payloads) {
      setState(() {
        this._projects = payloads[1];
        this._customFilter = payloads[2];
        this._stateCategories = payloads[3];
        this._tabController = TabController(vsync: this, length: this._stateCategories.length);
        this._loaded = true;
      });
    }, onError: (e) {
      print(e);
    }).then((item) {
      updateIssues(
        S.of(context).issue_assign_to_me,
        jql: JQL_ISSUE_ASSIGN_TO_ME,
        popRouter: false,
      );
    });
  }

  IconData getStatusCategoryIcon(String key) {
    switch (key) {
      case 'new':
        return Icons.assignment_late;
      case 'indeterminate':
        return Icons.assignment_returned;
      case 'done':
        return Icons.assignment_turned_in;
      default:
        return Icons.assistant_photo;
    }
  }

  bool isIssueInStateCategory(issue, stateCategory) =>
      issue['fields']['status']['statusCategory']['key'] == stateCategory['key'];

  /*
  * 初始化页面以及点击 drawer 之后触发
  * */
  Future updateIssues(
    String title, {
    String jql,
    String projectKey,
    bool popRouter: true,
  }) async {
    setState(() {
      this._appBarTitle = title;
      this._issues = [];
      this._fetching = true;
      if (popRouter) {
        Navigator.of(context).pop();
      }
    });
    fetchIssueList(
      jql: jql,
      projectKey: projectKey,
    ).then((issues) {
      setState(() {
        this._issues = issues;
        this._fetching = false;
      });
    });
  }

  handleSwitchToDartTheme(bool isDarkMode) {
    dispatchAppAction(
      context,
      RefreshThemeDataAction(isDarkMode ? Themes.DARK : Themes.DEFAULT),
    );
  }

  Widget buildMainContent(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      children: _stateCategories.map((stateCategory) {
        // every tab
        final issues = _issues.where((issue) => isIssueInStateCategory(issue, stateCategory));
        return issues.length > 0
            // render every column
            ? ListView(
                children: issues.map((issue) => IssueItem(issue) as Widget).toList()
                  ..add(EndLine(S.of(context).no_more_data)),
              )
            // render tips
            : PlaceholderText(
                S.of(context).no_data,
                transform: Matrix4.translationValues(0, -50, 0),
              );
      }).toList(),
    );
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle != null
            ? Text(
                _appBarTitle,
                overflow: TextOverflow.ellipsis,
              )
            : Text(S.of(context).dashboard),
        bottom: TabBar(
          controller: _tabController,
          labelPadding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 15,
          ),
          tabs: _stateCategories
              .map((item) => TabTitle(
                    title: item['name'],
                    icon: getStatusCategoryIcon(item['key']),
                  ))
              .toList(),
          isScrollable: true,
        ),
      ),
      drawer: buildDrawer(context),
      body: _loaded && !_fetching
          ? buildMainContent(context)
          : Loading(
              backgroundColor: null,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewIssue(),
            ),
          );
        },
        tooltip: S.of(context).new_issue,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
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
          child: CustomAvatar(reduxStore.userInfo.avatarUrls),
        ),
        decoration: BoxDecoration(
          //用一个BoxDecoration装饰器提供背景图片
          image: DecorationImage(
            image: AssetImage(
              getAppState(context).theme == Themes.DARK
                  ? 'assets/images/drawer_bg_dark.jpg'
                  : 'assets/images/drawer_bg.jpg',
            ),
            alignment: Alignment.center,
            fit: BoxFit.cover,
          ),
          color: Theme.of(context).primaryColor,
        ),
      ),
    ];
    // add fix filter
    listItems.addAll([
      ListTile(
        title: Text(S.of(context).issue_assign_to_me),
        leading: Icon(Icons.assignment),
        onTap: () {
          this.updateIssues(
            S.of(context).issue_assign_to_me,
            jql: JQL_ISSUE_ASSIGN_TO_ME,
          );
        },
      ),
      ListTile(
        title: Text(S.of(context).my_report_issue),
        leading: Icon(Icons.bug_report),
        onTap: () {
          this.updateIssues(
            S.of(context).my_report_issue,
            jql: JQL_MY_REPORT_ISSUE,
          );
        },
      ),
    ]);
    // add custom filters
    listItems.addAll(this._customFilter.map((filter) => ListTile(
        title: Text(filter['name']),
        leading: Icon(Icons.favorite),
        onTap: () {
          this.updateIssues(
            filter['name'],
            jql: filter['jql'],
          );
        })));
    // add projects
    listItems.add(Divider());
    listItems.addAll(this._projects.map((project) => ListTile(
          title: Text(project['name']),
          leading: CustomSvg(
            getAvatarUrl(project),
            width: 32,
          ),
          onTap: () {
            this.updateIssues(
              project['name'],
              projectKey: project['key'],
            );
          },
        )));
    listItems.add(Divider());
    // add settings
    listItems.addAll([
      ListTile(
        title: Text(S.of(context).dark_mode),
        leading: Icon(Icons.brightness_2),
        onTap: () => this.handleSwitchToDartTheme(getAppState(context).theme != Themes.DARK),
        trailing: Switch(
          value: getAppState(context).theme == Themes.DARK,
          onChanged: this.handleSwitchToDartTheme,
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
        padding: const EdgeInsets.all(0.0),
        children: listItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: buildScaffold(context),
      onWillPop: () {
        if (Navigator.of(context).canPop() || _doubleClickToExit) {
          return Future.value(true);
        } else {
          Fluttertoast.showToast(msg: S.of(context).double_click_to_exit);
          _doubleClickToExit = true;
          Timer(
            const Duration(milliseconds: 500),
            () {
              _doubleClickToExit = false;
            },
          );
        }
      },
    );
  }
}

class TabTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  TabTitle({
    @required this.icon,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 5),
          child: Icon(this.icon),
        ),
        Text(
          this.title,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class IssueItem extends StatelessWidget {
  final Map data;

  const IssueItem(this.data);

  Widget buildHeader(BuildContext context) {
    const double lineHeight = 30.0;
    final payload = data['fields'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Wrap(
          alignment: WrapAlignment.center,
          children: <Widget>[
            // priority icon
            Container(
              alignment: Alignment.center,
              height: lineHeight,
              child: payload['priority'] != null
                  ? Wrap(
                      children: <Widget>[
                        CustomSvg(
                          payload['priority']['iconUrl'],
                          width: 16,
                        ),
                        // priority name
                        Text(
                          $_get(
                            payload,
                            ['priority', 'name'],
                            defaultData: S.of(context).unspecified,
                          ),
                        ),
                      ],
                    )
                  : Icon(
                      Icons.favorite,
                      color: Theme.of(context).accentColor,
                    ),
            ),
            // issue type icon
            Container(
              alignment: Alignment.center,
              height: lineHeight,
              padding: EdgeInsets.only(left: 10),
              child: CustomSvg(
                payload['issuetype']['iconUrl'],
                width: 16,
              ),
            ),
            // issue key
            Container(
              alignment: Alignment.center,
              height: lineHeight,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                data['key'],
                style: Theme.of(context).textTheme.title,
              ),
            ),
            // resolution
            Container(
              alignment: Alignment.center,
              height: lineHeight,
              child: Text(
                $_get(payload, ['resolution', 'name'], defaultData: ''),
                style: Theme.of(context).textTheme.display1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        // reporter and assignee
        Wrap(
          alignment: WrapAlignment.center,
          children: <Widget>[
            CustomAvatar(
              getAvatarUrl(payload['reporter']),
              squareSize: lineHeight,
            ),
            FractionallySizedBox(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            CustomAvatar(
              getAvatarUrl(payload['assignee']),
              squareSize: lineHeight,
            ),
          ],
        )
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    final payload = data['fields'];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        payload['summary'],
        textAlign: TextAlign.left,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final payload = data['fields'];
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Issue(data['key'])));
      },
      child: CustomCard(
        header: buildHeader(context),
        body: buildBody(context),
        createdTime: payload['created'],
        updatedTime: payload['updated'],
      ),
    );
  }
}
