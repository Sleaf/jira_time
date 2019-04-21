import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jira_time/constant/svgAvatars.dart';
import 'package:jira_time/widgets/networkImageWithCookie.dart';

class CustomAvatar extends StatelessWidget {
  final String url;

  const CustomAvatar(this.url);

  Widget buildImage(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).backgroundColor,
      backgroundImage: this.url != null
          ? NetworkImageWithCookie(this.url)
          : AssetImage('assets/images/useravatar_placeholder.png'),
    );
  }

  Widget buildSvg(BuildContext context) {
    return SvgPicture(
      AdvancedNetworkSvg(
        this.url,
        SvgPicture.svgByteDecoder,
        useDiskCache: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return this.url != null && SVG_AVATAR_ENDS.any((endStr) => this.url.endsWith(endStr))
        ? this.buildSvg(context)
        : this.buildImage(context);
  }
}
