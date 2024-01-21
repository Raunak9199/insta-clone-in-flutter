import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:socio_chat/features/view/pages/auth/domain/usecases/user/get_single_user_usecase.dart';
import 'package:socio_chat/features/view/pages/chat-room/widgets/widgets.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/no_data_found_widget.dart';
import 'package:socio_chat/global-widgets/app_dialogbox.dart';
import 'package:socio_chat/global-widgets/app_loader.dart';

import 'conn_users_page_list_widget.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;

class HasConnectionWidget extends StatefulWidget {
  const HasConnectionWidget({super.key, required this.user});

  final UserEntity user;

  @override
  State<HasConnectionWidget> createState() => _HasConnectionWidgetState();
}

class _HasConnectionWidgetState extends State<HasConnectionWidget> {
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
        shrinkWrap: true,
        itemCount: widget.user.connections!.length,
        itemBuilder: (context, index) {
          return StreamBuilder<List<UserEntity>>(
              stream: inj.sl<UserUseCase>().call(
                    widget.user.connections![index],
                  ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: AppLoader(),
                  );
                }
                if (snapshot.data!.isEmpty) {
                  return const NoDataFoundWidget();
                }

                final userData = snapshot.data!.first;

                return ConnectionsUsersListPageWidget(userData: userData);
              });
        },
      ),
    );
  }
}
