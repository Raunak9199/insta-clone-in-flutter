import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:socio_chat/constants/colors.dart';

class TermsAndCond extends StatelessWidget {
  const TermsAndCond({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h)
          .copyWith(top: 2.h),
      child: SizedBox(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "By clicking signup, you agree to our ",
            style: Get.textTheme.bodySmall!.copyWith(color: AppColor.monoAlt),
            children: [
              TextSpan(
                // recognizer:,
                text: "Terms and Conditions",
                style: Get.textTheme.bodySmall!.copyWith(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                    color: AppColor.secondaryDark),
              )
            ],
          ),
        ),
      ),
    );
  }
}
