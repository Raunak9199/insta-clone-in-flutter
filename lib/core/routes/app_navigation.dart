import 'package:get/get.dart';

class Nav {
  const Nav._();

  static void pop({String? result}) => Get.back(result: result);

  static Future? pushNamed(
    String routeName, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    return Get.toNamed(routeName, parameters: parameters, arguments: arguments);
  }

  static Future? popAndPushNamed(
    String routeName, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) =>
      Get.offNamed(routeName, parameters: parameters, arguments: arguments);

  static Future? pushAndRemoveUntilNamed(
    String routeName, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) =>
      Get.offAllNamed(routeName, parameters: parameters, arguments: arguments);
}
