import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSvg extends StatelessWidget {
  final String url;
  final double width;

  const CustomSvg(this.url, {Key key, this.width}) : super(key: key);

  Widget buildEmptySvg(BuildContext context) {
    return SvgPicture.string('<svg viewBox="0 0 1 1"></svg>');
  }

  @override
  Widget build(BuildContext context) {
    return this.url != null
        ? SvgPicture(
            AdvancedNetworkSvg(
              this.url,
              SvgPicture.svgByteDecoder,
              useDiskCache: true,
            ),
            width: this.width,
          )
        : buildEmptySvg(context);
  }
}
