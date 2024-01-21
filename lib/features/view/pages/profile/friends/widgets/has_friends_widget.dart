import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/user/get_single_user_usecase.dart';
import 'package:socio_chat/global-widgets/app_dialogbox.dart';
import 'package:socio_chat/global-widgets/app_loader.dart';

import 'friends_user_card_widget.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;

class HasFriendsWidget extends StatefulWidget {
  const HasFriendsWidget({super.key, required this.user});

  final UserEntity user;

  @override
  State<HasFriendsWidget> createState() => _HasFriendsWidgetState();
}

class _HasFriendsWidgetState extends State<HasFriendsWidget> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          } else {
            setState(() {
              isAlertSet = false;
            });
          }
        },
      );
  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('No Connectivity'),
          content:
              const Text('Please make sure you have an internet connection.'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                bool? shouldClose = await openAppDialog(
                  context: context,
                  params: OpenDialogModel(
                    title: "Exit app?",
                    isDismissible: true,
                    subTitle: "Are you sure, you want to exit the app?".tr,
                  ),
                );

                return Future.value(shouldClose ?? false);
              },
              child: const Text("Exit"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.user.friends!.length,
        itemBuilder: (context, index) {
          Stream<List<UserEntity>>? stream = inj.sl<UserUseCase>().call(
                widget.user.friends![index],
              );
          return StreamBuilder<List<UserEntity>>(
              stream: stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: AppLoader(),
                  );
                }
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No data found.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }
                final userData = snapshot.data!.first;

                return FriendsUserCardWidget(userData: userData);
              });
        },
      ),
    );
  }
}
