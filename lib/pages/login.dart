import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jira_time/actions/actions.dart';
import 'package:jira_time/generated/i18n.dart';
import 'package:jira_time/main.dart';
import 'package:jira_time/redux/store.dart';
import 'package:jira_time/util/system.dart';
import 'package:jira_time/widgets/loading.dart';
import 'package:jira_time/pages/dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _hostController =
      TextEditingController(text: stateFromMain.env.baseUrl ?? 'https://');
  TextEditingController _usernameController =
      TextEditingController(text: stateFromMain.env.savedUsername);
  TextEditingController _pwdController = TextEditingController();
  GlobalKey _formKey = GlobalKey<FormState>();
  bool _formValidated = false; // 表单是否验证通过
  bool _fetching = false; // 是否正在登录

  @override
  void initState() {
    super.initState();
    hideStatusBar();
  }

  handleLogin() async {
    setState(() {
      FocusScope.of(context).detach();
      this._fetching = true;
    });
    final errorMessage = await login(
      context,
      _hostController.text.trim(),
      _usernameController.text,
      _pwdController.text,
    );
    setState(() {
      this._fetching = false;
    });
    if (errorMessage == null) {
      // go to dashboard and remove this page
      print('go to dashboard');
      Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => Dashboard()),
        (route) => route == null,
      );
    } else {
      Fluttertoast.showToast(msg: errorMessage);
    }
  }

  Widget buildMainWidget(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          decoration: BoxDecoration(color: Color.fromRGBO(240, 240, 240, .5)),
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                margin: EdgeInsets.only(top: 75, bottom: 20),
                child: Image(
                  image: AssetImage("assets/images/logo.png"),
                ),
              ),
              buildForm(context),
            ],
          ),
        );
      },
    );
  }

  Widget buildForm(BuildContext context) {
    return Form(
      key: _formKey, //设置globalKey，用于后面获取FormState
      onChanged: () {
        setState(() => _formValidated = (_formKey.currentState as FormState).validate());
      },
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _hostController,
            decoration: InputDecoration(
              hintText: 'http(s)://jira.company.com',
              icon: Icon(Icons.cloud_queue),
            ),
            validator: (String content) {
              if (content.length == 0) {
                return S.of(context).validator_hostname_required;
              }
              if (!RegExp('^https?:\/\/').hasMatch(content)) {
                return S.of(context).validator_hostname_regx;
              }
              return null;
            },
          ),
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              hintText: S.of(context).username,
              icon: Icon(Icons.person),
            ),
            validator: (String content) {
              return content.length > 0 ? null : S.of(context).validator_username_required;
            },
          ),
          TextFormField(
            controller: _pwdController,
            decoration: InputDecoration(
              hintText: S.of(context).password,
              icon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (String content) {
              return content.length > 0 ? null : S.of(context).validator_password_required;
            },
          ),
          // 登录按钮
          Padding(
            padding: EdgeInsets.only(top: 28.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.all(15.0),
                    child: Text(S.of(context).login),
                    color: _formValidated
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).disabledColor,
                    textColor: Colors.white,
                    onPressed: _formValidated ? this.handleLogin : null,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buildWidgets = <Widget>[
      buildMainWidget(context),
    ];
    if (_fetching) {
      buildWidgets.add(Loading());
    }
    return Scaffold(
      body: Stack(children: buildWidgets),
    );
  }
}
