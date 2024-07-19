import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static const String _keySortingOrder = 'sortingOrder';
  static const String _keyThemeMode = 'themeMode';

  Future<void> setSortingOrder(String order) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySortingOrder, order);
  }

  Future<String?> getSortingOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySortingOrder);
  }

  Future<void> setThemeMode(bool isDarkMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyThemeMode, isDarkMode);
  }

  Future<bool> getThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyThemeMode) ?? false;
  }
}
