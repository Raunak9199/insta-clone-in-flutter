import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/image_display_widget.dart';
import 'package:socio_chat/global-widgets/app_appbar.dart';
import 'package:socio_chat/global-widgets/app_scaffold.dart';

class DisplayFullImage extends StatelessWidget {
  final UserEntity currentUser;
  const DisplayFullImage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    // user-prof
    return AppScaffold(
      appBar: AppNewAppBar(
        params: AppAppBarModel(
            isBack: Platform.isAndroid,
            isIosBack: Platform.isIOS,
            elevation: 0.4,
            title: "${currentUser.userName}",
            titleStyle: TextStyle(
              color: Colors.black,
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
            )),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
        child: Center(
          child: Hero(
            tag: "user-prof",
            transitionOnUserGestures: true,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.maxFinite,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: ImageDisplayWidget(
                  imgUrl: currentUser.profileUrl,
                  // imgUrl: imageFile!.path,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
