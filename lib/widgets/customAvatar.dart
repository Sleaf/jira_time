import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jira_time/constant/svgAvatars.dart';
import 'package:jira_time/widgets/customSvg.dart';
import 'package:jira_time/widgets/networkImageWithCookie.dart';

class CustomAvatar extends StatelessWidget {
  final String url;
  final double squareSize;
  final EdgeInsets margin;

  const CustomAvatar(this.url, {this.squareSize, this.margin});

  Widget buildImage(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).backgroundColor,
      backgroundImage: this.url != null
          ? NetworkImageWithCookie(this.url)
          : AssetImage('assets/images/useravatar_placeholder.png'),
    );
  }

  Widget buildSvg(BuildContext context) {
    return CustomSvg(this.url);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: this.margin,
      width: this.squareSize,
      height: this.squareSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: this.url != null && SVG_AVATAR_ENDS.any((endStr) => this.url.endsWith(endStr))
          ? this.buildSvg(context)
          : this.buildImage(context),
    );
  }
}
