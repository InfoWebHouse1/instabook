import 'package:shared_preferences/shared_preferences.dart';

class UseSimplePreference {
  static SharedPreferences? _sharedPreferences;
  static const _keyValueLiked = "isLiked";

  static Future init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }
  static Future setLikeValue(bool isLiked) async =>
      _sharedPreferences!.setBool(_keyValueLiked, isLiked);

  static Future getLikedValue() async {
    return _sharedPreferences!.getBool(_keyValueLiked);
  }
}