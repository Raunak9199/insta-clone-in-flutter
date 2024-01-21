import 'package:flutter/material.dart';
import 'package:socio_chat/core/routes/on_generate_route.dart';
import 'package:socio_chat/features/view/pages/chat-room/widgets/widgets.dart';
import 'package:socio_chat/global-widgets/global_widgets.dart';

class FriendsUserCardWidget extends StatelessWidget {
  const FriendsUserCardWidget({
    super.key,
    required this.userData,
  });

  final UserEntity userData;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // drop shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.usersProfilePageView,
              arguments: userData.uid,
            );
          },
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                width: 40,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AppImage(
                    userData.profileUrl!,
                  ),
                ),
              ),
              SizedBox(width: 10.h),
              Text(
                "${userData.userName}",
                style: TextStyle(
                  color: AppColor.secondaryDark,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
