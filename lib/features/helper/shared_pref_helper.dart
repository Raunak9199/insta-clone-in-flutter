import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static const String _hasJoinedChatKey = 'has_joined_chat';

  static Future<bool> getHasJoinedChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasJoinedChatKey) ?? false;
  }

  static Future<void> setHasJoinedChat(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_hasJoinedChatKey, value);
  }
}
