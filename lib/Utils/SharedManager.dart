import 'package:shared_preferences/shared_preferences.dart';

class SharedManager {
  static Future<void> setUserNumber(String number) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("number", number);
  }

  static Future<String> getUserNumber() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("number") ?? "";
  }

  static Future<void> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
