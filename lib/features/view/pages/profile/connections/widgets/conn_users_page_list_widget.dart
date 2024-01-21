import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/core/routes/on_generate_route.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/global-widgets/global_widgets.dart';

class ConnectionsUsersListPageWidget extends StatelessWidget {
  const ConnectionsUsersListPageWidget({
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
        child: GestureDetector(
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
                style: const TextStyle(
                  color: AppColor.secondaryDark,
                  fontSize: 15,
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
