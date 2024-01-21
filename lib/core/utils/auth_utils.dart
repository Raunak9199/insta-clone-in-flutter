class AuthUtils {
  const AuthUtils._();

  static bool isOnboarded = false;

  static Future<void> getAuthLocalData() async {
    // await getIsOnBoarded();
  }

  // static Future<void> setIsOnBoarded({bool val = false}) async {
  //   await box.write(AppKeys.isOnboarded, val);
  //   await getIsOnBoarded();
  // }

  // static Future<void> getIsOnBoarded() async {
  //   if (box.hasData(AppKeys.isOnboarded)) {
  //     isOnboarded = box.read(AppKeys.isOnboarded) as bool;
  //   }
  // }

  // static Future<void> clearData() async {
  //   // Nav.pushAndRemoveUntilNamed(Routes.onboardingView);
  //   await box.erase();
  //   await setIsOnBoarded(val: true);
  //   isOnboarded = false;
  // }
}
