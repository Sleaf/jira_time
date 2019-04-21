import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jira_time/actions/api.dart';
import 'package:jira_time/generated/i18n.dart';
import 'package:jira_time/util/redux.dart';
import 'package:jira_time/util/response.dart';
import 'package:jira_time/widgets/loading.dart';

class NewIssue extends StatefulWidget {
  @override
  _NewIssueState createState() => _NewIssueState();
}

class _NewIssueState extends State<NewIssue> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  GlobalKey _issueFormKey = GlobalKey<FormState>();
  TextEditingController _summaryController = new TextEditingController();
  TextEditingController _assigneeController = new TextEditingController();
  bool _loaded = false; // 是否正在初始化完成
  bool _fetching = false; // 是否正在异步传输
  List _projects = [];
  Map _formError = {};
  var _selectedProject;
  var _selectedIssueType;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    //fetch project meta
    fetchIssueMeta().then((projects) {
      setState(() {
        this._projects = projects;
        this._selectedProject = projects.first;
        this._selectedIssueType = getAvailableIssueTypes(projects.first['issuetypes']).first;
        this._loaded = true;
      });
    }, onError: (e) {
      print(e);
    });
    // add assignee listener
    this._assigneeController.addListener(this.handleInputAssignee);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    // add assignee listener
    this._assigneeController.removeListener(this.handleInputAssignee);
  }

  List getAvailableIssueTypes(List issueTypes) =>
      issueTypes.where((type) => !type['subtask']).toList();

  handleInputAssignee() async {
    // clear error
    if (this._formError.containsKey('assignee')) {
      setState(() {
        this._formError.removeWhere((key, value) => key == 'assignee');
      });
    }
  }

  handleCreateIssue() async {
    FocusScope.of(context).detach();
    if ((_issueFormKey.currentState as FormState).validate()) {
      setState(() {
        this._fetching = true;
      });
      var payload;
      try {
        payload = await createIssue(
          _selectedProject['id'],
          _selectedIssueType['id'],
          _summaryController.text,
          assignee: _assigneeController.text,
        );
      } catch (error) {
        // something
        if (error is DioError && error.type == DioErrorType.RESPONSE) {
          return setState(() {
            final errorMsg = getServerErrorMsgHelper(error);
            if (errorMsg.length > 0) {
              Fluttertoast.showToast(msg: getServerErrorMsgHelper(error));
            } else {
              this._formError = error.response.data['errors'];
            }
          });
        } else {
          Fluttertoast.showToast(msg: S.of(context).error_server);
        }
      } finally {
        setState(() {
          this._fetching = false;
        });
      }
      // todo to issue detail
      print('go to detail');
      print(payload);
    }
  }

  Widget buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).newIssue),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            tooltip: S.of(context).create,
            onPressed: this.handleCreateIssue,
          ),
        ],
      ),
      body: this._loaded
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: buildForm(context),
            )
          : Loading(),
    );
  }

  Widget buildForm(BuildContext context) {
    return Form(
      key: _issueFormKey, //设置globalKey，用于后面获取FormState
      child: Column(
        children: <Widget>[
          /// project
          DropdownButtonFormField(
            decoration: InputDecoration(
              prefix: FormLabel(S.of(context).project),
            ),
            value: this._selectedProject,
            onChanged: (value) {
              setState(() {
                this._selectedProject = value;
                this._selectedIssueType = getAvailableIssueTypes(value['issuetypes']).first;
              });
            },
            items: this
                ._projects
                .map((project) => DropdownMenuItem(
                    value: project,
                    child: Row(children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: SvgPicture(
                          AdvancedNetworkSvg(
                            getAvatarUrl(project),
                            SvgPicture.svgByteDecoder,
                            useDiskCache: true,
                          ),
                          width: 32,
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(
                          maxWidth: 190,
                        ),
                        child: Text(
                          project['name'],
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ])))
                .toList(),
          ),

          /// issue type
          DropdownButtonFormField(
            decoration: InputDecoration(
              prefix: FormLabel(S.of(context).issue_type),
            ),
            value: this._selectedIssueType,
            onChanged: (value) {
              setState(() {
                this._selectedIssueType = value;
              });
            },
            items: getAvailableIssueTypes(this._selectedProject['issuetypes']).map((issueTypes) {
              final String pictureUrl = issueTypes['iconUrl'];
              final isImage = RegExp('(png|jpe?g)\$').hasMatch(pictureUrl);
              const iconWidth = 32.0;
              return DropdownMenuItem(
                  value: issueTypes,
                  child: Row(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 5),
                      child: isImage
                          ? Image.network(
                              pictureUrl,
                              width: iconWidth,
                            )
                          : SvgPicture(
                              AdvancedNetworkSvg(
                                pictureUrl,
                                SvgPicture.svgByteDecoder,
                                useDiskCache: true,
                              ),
                              width: iconWidth,
                            ),
                    ),
                    Text(issueTypes['name']),
                  ]));
            }).toList(),
          ),

          /// Summary
          TextFormField(
            controller: _summaryController,
            decoration: InputDecoration(
              labelText: S.of(context).summary,
            ),
            autovalidate: true,
            validator: (String content) {
              return content.length > 0 ? null : S.of(context).validator_summary_required;
            },
          ),

          /// Assignee
          TextFormField(
            controller: _assigneeController,
            decoration: InputDecoration(
              labelText: S.of(context).assignee,
              suffix: GestureDetector(
                onTap: () {
                  setState(() {
                    this._assigneeController.text = getAppState(context).userInfo.name;
                  });
                },
                child: Text(
                  S.of(context).assign_to_me,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              errorText: this._formError['assignee'],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> buildWidgets = [
      buildScaffold(context),
    ];
    if (this._fetching) {
      buildWidgets.add(Loading());
    }
    return Scaffold(
      body: Stack(children: buildWidgets),
    );
  }
}

class FormLabel extends StatelessWidget {
  final String text;

  const FormLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: EdgeInsets.only(left: 10),
      child: Text(
        this.text + " : ",
        style: Theme.of(context).textTheme.body2,
      ),
    );
  }
}
