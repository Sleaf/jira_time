import 'package:flutter/material.dart';
import 'package:jira_time/generated/i18n.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).login),
      ),
      body: Text('Hello World!'),
//      body: Padding(
//        padding: EdgeInsets.fromLTRB(20, 100, 20, 0),
//        child: Column(
//          mainAxisSize: MainAxisSize.max,
//          mainAxisAlignment: MainAxisAlignment.start,
//          children: <Widget>[
//            Container(
//              margin: EdgeInsets.fromLTRB(0, 25, 0, 15),
//              child: Row(
//                children: <Widget>[
//                  Expanded(
//                    flex: 3,
//                    child: Container(
//                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                      child: TextField(
//                        controller: _searchBarController,
//                        onSubmitted: toDetailPage,
//                        decoration: InputDecoration(
//                          hintText: ' 输入搜索关键字',
//                        ),
//                      ),
//                    ),
//                  ),
//                  Expanded(
//                      flex: 1,
//                      child: RaisedButton(
//                        child: Text(
//                          '搜索',
//                          style: Theme.of(context).textTheme.button,
//                        ),
//                        color: Theme.of(context).primaryColor,
//                        onPressed: toDetailPage,
//                      ))
//                ],
//              ),
//            ),
//            Column(
//              children: <Widget>[
//                Row(
//                  mainAxisSize: MainAxisSize.max,
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: <Widget>[
//                    Padding(
//                      padding: EdgeInsets.only(bottom: 10),
//                      child: Text('热门影片'),
//                    ),
//                  ],
//                ),
//                Wrap(
//                  children:
//                      _hotMovies.map((item) => HotMovieItem(item)).toList(),
//                )
//              ],
//            )
//          ],
//        ),
//      ),
    );
  }
}
