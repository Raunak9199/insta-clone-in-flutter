import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/global-widgets/app_image.dart';

class BottomSheetAppBar extends StatelessWidget {
  const BottomSheetAppBar({
    super.key,
    this.title,
    this.style,
    this.closeIcon,
    this.margin,
    this.marginAllRadius,
    this.onTap,
    this.isDivider = false,
    this.heightAfterDivider,
    this.body,
    this.closeIconPath,
    this.haveCloseIcon = false,
    this.rowAxisAlignment = MainAxisAlignment.spaceBetween,
    this.colCrossAxisAlignment = CrossAxisAlignment.center,
  });
  final String? title;
  final TextStyle? style;
  final Widget? closeIcon;
  final EdgeInsetsGeometry? margin;
  final double? marginAllRadius;
  final VoidCallback? onTap;
  final bool isDivider;
  final double? heightAfterDivider;
  final Widget? body;
  final String? closeIconPath;
  final bool haveCloseIcon;
  final MainAxisAlignment rowAxisAlignment;
  final CrossAxisAlignment colCrossAxisAlignment;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: colCrossAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: margin ?? EdgeInsets.all(marginAllRadius ?? 8.w),
            child: Row(
              mainAxisAlignment: rowAxisAlignment,
              children: [
                haveCloseIcon
                    ? Text(
                        title ?? '',
                        style: style ??
                            Get.textTheme.bodyLarge!.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColor.monoDark.withOpacity(0.8),
                            ),
                      )
                    : const SizedBox.shrink(),
                haveCloseIcon
                    ? IconButton(
                        constraints:
                            BoxConstraints(maxHeight: 16.w, maxWidth: 16.w),
                        padding: EdgeInsets.zero,
                        icon: closeIcon ??
                            AppImage(
                              closeIconPath ?? "",
                              width: 16.w,
                              height: 16.w,
                              color: AppColor.monoAlt.withOpacity(0.6),
                            ),
                        onPressed: onTap ?? () => Navigator.pop(context),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          // if (isDivider) Container(height: 1.h, color: AppColor.monoGrey3),
          // if (heightAfterDivider != null && heightAfterDivider! > 0)
          //   SizedBox(height: heightAfterDivider),
          body ?? const SizedBox.shrink(),
        ],
      );
}
