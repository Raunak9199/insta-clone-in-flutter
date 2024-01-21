import 'package:get/get.dart';
import 'package:socio_chat/global-widgets/bottom-nav/bottom_nav_bar_controller.dart';

class BottomNavBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavBarController>(() => BottomNavBarController());
  }
}
