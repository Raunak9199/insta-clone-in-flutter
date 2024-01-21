import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppImage extends StatelessWidget {
  final String path;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Color? color;
  final bool isFileImage;

  const AppImage(
    this.path, {
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.color,
    this.isFileImage = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isFileImage) {
      return Image.file(File(path), fit: fit, height: height, width: width);
    }

    final bool isLocalImage = !path.contains("http") && !path.contains(".svg");
    final bool isNetworkImage = path.contains("http") && !path.contains(".svg");
    final bool isLocalSVG = !path.contains("http") && path.contains(".svg");
    final bool isNetworkSVG = path.contains("http") && path.contains(".svg");

    if (isLocalImage) {
      return Image.asset(path, fit: fit, height: height, width: width);
    } else if (isNetworkImage) {
      return Image.network(path, fit: fit, height: height, width: width);
    } else if (isLocalSVG) {
      return SvgPicture.asset(
        path,
        fit: fit,
        height: height,
        width: width,
        color: color,
        theme: SvgTheme(currentColor: color!),
      );
    } else if (isNetworkSVG) {
      return SvgPicture.network(path, fit: fit, height: height, width: width);
    } else {
      return Image.asset(
        "assets/logo.png",
        fit: fit,
        height: height,
        width: width,
      );
    }
  }
}
