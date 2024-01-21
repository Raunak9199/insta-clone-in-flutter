import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/features/view/pages/chat-room/widgets/global_chat_view.dart';

class ChatHeaderWidget extends StatelessWidget {
  const ChatHeaderWidget({
    super.key,
    // required this.context,
    required this.widget,
  });

  // final BuildContext context;
  final GlobalChatView widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: double.maxFinite,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.secondaryDark.withOpacity(0.67),
            Colors.red.withOpacity(0.4),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: FaIcon(
                    FontAwesomeIcons.arrowLeft,
                    color: Colors.white,
                    size: 22.w,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    "Global Chat Room",
                    style: Get.textTheme.titleLarge!
                        .copyWith(color: Colors.white, fontSize: 20.sp),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    (widget.user.name == null || widget.user.name!.isEmpty)
                        ? "${widget.user.userName}"
                        : "${widget.user.userName} (${widget.user.name})",
                    style: Get.textTheme.titleLarge!
                        .copyWith(color: Colors.white, fontSize: 16.sp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
