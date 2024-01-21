import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:socio_chat/constants/colors.dart';

class NoCommentWidget extends StatelessWidget {
  const NoCommentWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          "No comments yet. Be the first one to write a comment.",
          softWrap: true,
          textAlign: TextAlign.center,
          style: Get.textTheme.bodyLarge!.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.monoAlt,
          ),
        ),
      ),
    );
  }
}
