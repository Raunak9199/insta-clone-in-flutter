import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackBar {
  static BuildContext? context;

  AppSnackBar._();
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      showSnackbar({
    required String msg,
    String? title,
    int duration = 3,
  }) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    return ScaffoldMessenger.of(context!).showSnackBar(snackBar);
    /* 
    return Get.rawSnackbar(
      title: title,
      messageText: Text(
        msg,
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColor.monoWhite,
          fontWeight: FontWeight.w200,
        ),
      ),
      backgroundColor: AppColor.primaryClr,
      duration: Duration(seconds: duration),
    ); */
  }
}

class AppErrorSnackBar {
  AppErrorSnackBar._();

  static void showSnackbar({
    required String msg,
    String? title,
    int duration = 3,
  }) {
    Get.snackbar(
      title ?? '', // Using the optional title or an empty string if null
      msg, // The main message
      icon: const Icon(Icons.error_outline),
      shouldIconPulse: true,
      barBlur: 20,
      isDismissible: true,
      duration: Duration(seconds: duration), // Use the passed duration
      snackPosition: SnackPosition.TOP,
    );
  }
}
class NewAppSnackBar {
  NewAppSnackBar._();

  static void showSnackbar({
    required String msg,
    String? title,
    int duration = 3,
  }) {
    Get.snackbar(
      title ?? '', // Using the optional title or an empty string if null
      msg, // The main message
      icon: const Icon(Icons.notification_important_outlined),
      shouldIconPulse: true,
      barBlur: 20,
      isDismissible: true,
      duration: Duration(seconds: duration), // Use the passed duration
      snackPosition: SnackPosition.TOP,
    );
  }
}
