import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:socio_chat/constants/colors.dart';
import 'package:socio_chat/global-widgets/app_appbar.dart';
import 'package:socio_chat/global-widgets/app_dialogbox.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.scaffoldKey,
    this.drawer,
    this.isConfirmExit = false,
    this.isConfirmLogOut = false,
    this.backgroundColor,
    required this.body,
    this.appBar,
    this.onWillPop,
    this.resizeToAvoidBottomInset = false,
    this.floatingActionButtonLocation =
        FloatingActionButtonLocation.centerFloat,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.withBackground = true,
    this.withScrollable = false,
    this.haveAppBar = false,
  });
  final Key? scaffoldKey;
  final bool isConfirmExit;
  final bool isConfirmLogOut;
  final Color? backgroundColor;
  final Widget? body;
  final AppNewAppBar? appBar;
  final Future<bool> Function()? onWillPop;
  final bool? resizeToAvoidBottomInset;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final bool withBackground;
  final bool withScrollable;
  final bool haveAppBar;

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: onWillPop ??
            () {
              if (isConfirmExit) {
                openAppDialog(
                  context: context,
                  params: OpenDialogModel(
                    title: "aut_exitAppStr".tr,
                    subTitle: "aut_areYouSureQuitStr".tr,
                  ),
                );
              } else if (isConfirmLogOut) {
                openAppDialog(
                  context: context,
                  params: OpenDialogModel(
                      title: "aut_confirmLogOutStr".tr,
                      subTitle: "aut_logOutMsgStr".tr,
                      onConfirm: () {
                        // TODO
                      }
                      // onConfirm: () async => AuthUtils.clearData(),
                      ),
                );
              }
              return Future.value(true);
            },
        child: Scaffold(
          key: scaffoldKey,
          drawer: drawer,
          backgroundColor: backgroundColor ?? AppColor.monoWhite,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          floatingActionButtonLocation: floatingActionButtonLocation,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
          appBar: appBar,
          body: body,
        ),
      );
}
