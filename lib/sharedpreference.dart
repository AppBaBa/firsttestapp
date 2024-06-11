import 'package:shared_preferences/shared_preferences.dart';

class PrefrencesTest {
  static SharedPreferences? sharedPreferences;
  static const keyName = 'keyname';

  static Future init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future setPreferences(bool value) async {
    await sharedPreferences?.setBool(keyName, value);
  }

  static bool? getPreference() => sharedPreferences?.getBool(keyName);
}
