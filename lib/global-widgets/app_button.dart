import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.height,
    required this.width,
    required this.childText,
    required this.darkBackgroundClr,
    required this.radius,
    required this.style,
    required this.onPressed,
    required this.borderClr,
    this.prefixIcon,
    // required this.isEnabled,
  });
  final double height;
  final double width;
  final String childText;
  final Color darkBackgroundClr;
  final double radius;
  final TextStyle style;
  final VoidCallback onPressed;
  final Color borderClr;
  final Widget? prefixIcon;
  // bool isEnabled = true;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      // isEnabled
      //     ? () {
      //         debugPrint("CLicked");
      //         onPressed;
      //       }
      //     : null,
      borderRadius: BorderRadius.circular(radius + 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        height: height,
        width: width,
        decoration: BoxDecoration(
          // color: isEnabled ? darkBackgroundClr : Colors.grey,
          color: darkBackgroundClr,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderClr),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            prefixIcon ?? Container(),
            SizedBox(width: prefixIcon != null ? 10.w : 0.w),
            Text(childText, style: style),
          ],
        ),
      ),
    );
  }
}
