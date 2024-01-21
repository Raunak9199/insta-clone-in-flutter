import 'package:flutter/material.dart';
import 'package:socio_chat/features/view/pages/chat-room/widgets/widgets.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/image_display_widget.dart';

class CmntProfilePicWidget extends StatelessWidget {
  const CmntProfilePicWidget({
    super.key,
    required this.singUser,
  });

  final UserEntity singUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      height: 30.h,
      decoration: BoxDecoration(
        color: AppColor.secondaryClr,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
            // color: AppColor.monoGrey3,
            ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: ImageDisplayWidget(imgUrl: singUser.profileUrl),
      ),
    );
  }
}
