
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MessageButton extends StatelessWidget {
  const MessageButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });
  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.w, horizontal: 3.w)
          .copyWith(right: 5.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                spreadRadius: 0.4,
                blurRadius: 5,
                offset: const Offset(0, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: FaIcon(
              icon,
              size: 22.w,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}