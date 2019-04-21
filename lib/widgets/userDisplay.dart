import 'package:flutter/material.dart';
import 'package:jira_time/generated/i18n.dart';
import 'package:jira_time/util/lodash.dart';
import 'package:jira_time/util/response.dart';
import 'package:jira_time/widgets/customAvatar.dart';

class UserDisplay extends StatelessWidget {
  final userData;

  const UserDisplay(this.userData);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        CustomAvatar(
          getAvatarUrl(this.userData),
          squareSize: 20,
          margin: const EdgeInsets.only(right: 5),
        ),
        Text(
          $_get(
            this.userData,
            ['displayName'],
            defaultData: S.of(context).unassigned,
          ),
        ),
      ],
    );
  }
}
