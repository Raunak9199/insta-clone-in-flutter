import 'package:flutter/services.dart';
import 'package:socio_chat/core/utils/auth_utils.dart';

class AppUtils {
  const AppUtils._();

  static Future<void> getStoredData() async {
    await AuthUtils.getAuthLocalData();
  }

  static List<TextInputFormatter>? phoneInputFormatters() => [
        LengthLimitingTextInputFormatter(10),
        // FilteringTextInputFormatter.allow(
        // RegExp(RegexConstants.pinCodeFormat),
        // ),
        // FilteringTextInputFormatter.deny(RegExp('^[0-5]+')),
      ];
}
