import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio_chat/features/view/pages/search/search_view.dart';
import 'package:socio_chat/global-widgets/app_dialogbox.dart';

class BottomNavBarController extends GetxController {
  final rootScaffoldKey = GlobalKey<ScaffoldState>();
  var tabIndex = 0.obs;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subTitleController = TextEditingController();
  final PageController pageController = PageController();

  @override
  void dispose() {
    titleController.dispose();
    subTitleController.dispose();
    super.dispose();
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  final List<Widget> screenList = const [
    // HomeView(),
    SearchPage(),
    Scaffold(
      body: Center(
        child: Text("Chat"),
      ),
    ),
    Scaffold(
      body: Center(
        child: Text("Not"),
      ),
    ),
    // ProfilePage(),
  ];
  Future<bool> rootOnWillPop() {
    if (rootScaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.pop(Get.context!);
      return Future.value(false);
    } else if (tabIndex.value != 0) {
      tabIndex.value = 0;
      return Future.value(false);
    } else {
      openAppDialog(
        context: Get.context!,
        params: OpenDialogModel(
          title: "Exit app?",
          subTitle: "Are you sure, you want to exit the app?".tr,
        ),
      );
      return Future.value(true);
    }
  }
}
