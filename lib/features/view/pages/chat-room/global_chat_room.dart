import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:socio_chat/core/routes/on_generate_route.dart';
import 'package:socio_chat/features/view/pages/auth/data/models/user_model.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/user/get_curr_uid_usecase.dart';
import 'package:socio_chat/features/helper/shared_pref_helper.dart';
import 'package:socio_chat/cubit/user/user_cubit.dart';
import 'package:socio_chat/features/view/pages/chat-room/widgets/bodywidget.dart';
import 'package:socio_chat/global-widgets/app_dialogbox.dart';
import 'package:socio_chat/global-widgets/app_loader.dart';
import 'package:socio_chat/global-widgets/app_scaffold.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;

class GLobalChatRoom extends StatefulWidget {
  const GLobalChatRoom({super.key});

  @override
  State<GLobalChatRoom> createState() => _GLobalChatRoomState();
}

class _GLobalChatRoomState extends State<GLobalChatRoom> {
  String currentUid = "";
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
    BlocProvider.of<UserCubit>(context).getUsers(user: const UserEntity());

    inj.sl<GetCurrentUserUidUseCase>().call().then((value) {
      setState(() {
        currentUid = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, userState) {
      if (userState is UserLoaded) {
        final user = userState.users.firstWhere(
          (user) => user.uid == currentUid,
          orElse: () => const UserModel(),
        );
        return FutureBuilder(
          future: PreferencesHelper.getHasJoinedChat(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppScaffold(body: Center(child: AppLoader()));
            } else if (snapshot.hasError) {
              return AppScaffold(
                  body: Center(
                child: Text('Error: ${snapshot.error}'),
              ));
            } else {
              bool hasJoinedChat = snapshot.data ?? false;
              if (hasJoinedChat) {
                Future.delayed(Duration.zero, () {
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.globalChatView,
                    arguments: user,
                  );
                });
                return Container();
              } else {
                return BodyWidget(
                  user: userState,
                  currentUid: currentUid,
                );
              }
            }
          },
        );
      }
      return const Center(child: AppLoader());
    });
  }
}
