import 'package:flutter/material.dart';
import 'package:socio_chat/core/routes/on_generate_route.dart';
import 'package:socio_chat/cubit/user/user_cubit.dart';
import 'package:socio_chat/features/helper/shared_pref_helper.dart';
import 'package:socio_chat/features/view/pages/auth/data/models/user_model.dart';
import 'package:socio_chat/features/view/pages/chat-room/widgets/widgets.dart';
import 'package:socio_chat/global-widgets/app_elevated_button.dart';

class BodyWidget extends StatefulWidget {
  final UserLoaded user;
  final String currentUid;
  const BodyWidget({super.key, required this.user, required this.currentUid});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  navigate(users) => Navigator.pushReplacementNamed(
        context,
        Routes.globalChatView,
        arguments: users,
      );
  @override
  Widget build(BuildContext context) {
    final users = widget.user.users.firstWhere(
      (user) => user.uid == widget.currentUid,
      orElse: () => const UserModel(),
    );

    return AppScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Welcome ${users.name}",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Center(
            child: AppElevatedButton(
              title: 'Join Chat',
              color: AppColor.secondaryDark,
              isValid: true,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              onPressed: () async {
                await PreferencesHelper.setHasJoinedChat(true);
                navigate(users);
              },
              width: MediaQuery.of(context).size.width * 0.75,
              height: 50.h,
            ),
          ),
        ],
      ),
    );
  }
}
