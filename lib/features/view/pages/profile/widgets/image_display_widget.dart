import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socio_chat/global-widgets/app_loader.dart';

class ImageDisplayWidget extends StatelessWidget {
  const ImageDisplayWidget({
    super.key,
    this.imgUrl,
    this.imagFile,
    this.height,
    this.width,
    this.loader,
    this.fit,
  });
  final String? imgUrl;
  final File? imagFile;
  final double? height;
  final double? width;
  final Widget? loader;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    if (imagFile == null) {
      if (imgUrl == null || imgUrl == "") {
        return SizedBox(
          height: height,
          width: width,
          child: Image.asset(
            'assets/profile.png',
            fit: BoxFit.cover,
          ),
        );
      } else {
        return SizedBox(
          height: height,
          width: width,
          child: CachedNetworkImage(
            imageUrl: "$imgUrl",
            fit: fit ?? BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) {
              return Center(
                child: SizedBox(
                  height: 50.w,
                  width: 50.w,
                  child: const AppLoader(),
                ),
              );
            },
            errorWidget: (context, url, error) => SizedBox(
              height: height,
              width: width,
              child: loader != null
                  ? const Text(
                      "OOps! Something went wrong.",
                      softWrap: true,
                      textAlign: TextAlign.center,
                    )
                  : Image.asset(
                      'assets/profile.png',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        );
      }
    } else {
      return SizedBox(
        height: height,
        width: width,
        child: Image.file(
          imagFile!,
          fit: BoxFit.cover,
        ),
      );
    }
  }
}
