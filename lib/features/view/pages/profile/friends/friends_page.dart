import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/profile/connections/widgets/no_conn_found_widget.dart';
import 'package:socio_chat/features/view/pages/profile/friends/widgets/has_friends_widget.dart';
import 'package:socio_chat/global-widgets/app_appbar.dart';
import 'package:socio_chat/global-widgets/app_scaffold.dart';

class FriendsPage extends StatelessWidget {
  final UserEntity user;
  const FriendsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppNewAppBar(
        params: AppAppBarModel(
          title: "Friends",
          titleStyle: TextStyle(
            color: AppColor.monoDark,
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
          ),
          centerTitle: Platform.isIOS,
          isBack: Platform.isAndroid,
          isIosBack: Platform.isIOS,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          child: Column(
            mainAxisAlignment: user.totalFriends == 0
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              (user.totalFriends == 0)
                  ? const NoConnectionsFoundWidget(
                      title:
                          "No Friends found. Add some to see your friends list.")
                  : HasFriendsWidget(user: user),
            ],
          ),
        ),
      ),
    );
  }
}
