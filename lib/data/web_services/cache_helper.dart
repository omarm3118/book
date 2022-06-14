import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static init() async =>
      sharedPreferences = await SharedPreferences.getInstance();

  static Future<bool> setBool({
    required String key,
    required bool value,
  }) async {
    return await sharedPreferences.setBool(key, value);
  }

  static bool? getData({required String key}) => sharedPreferences.getBool(key);

  static Future<bool> removeData({required String key}) async =>
      await sharedPreferences.remove(key);
}
