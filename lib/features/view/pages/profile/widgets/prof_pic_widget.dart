import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socio_chat/global-widgets/app_image.dart';

class ProfilePicWidget extends StatelessWidget {
  final double height;
  final double width;
  final String? imageurl;
  const ProfilePicWidget({
    super.key,
    required this.height,
    required this.width,
    this.imageurl,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height.h,
        width: width.w,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: AppImage(
            imageurl ?? "assets/profile.png",
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
