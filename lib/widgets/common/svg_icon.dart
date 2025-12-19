import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;

  const SvgIcon({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}

class SvgIconNetwork extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;

  const SvgIconNetwork({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      url,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      placeholderBuilder: (context) => const CircularProgressIndicator(),
    );
  }
}

