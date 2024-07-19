import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  String _sortingCriteria = 'title';
  bool _isDarkMode = false;

  // Constructor that initializes the state
  AppState() {
    _loadPreferences();
  }

  String get sortingCriteria => _sortingCriteria;
  bool get isDarkMode => _isDarkMode;

  // Load preferences asynchronously
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _sortingCriteria = prefs.getString('sorting_criteria') ?? 'title';
    _isDarkMode = prefs.getBool('theme_mode') ?? false;
    notifyListeners();
  }

  // Update sorting criteria and save to preferences
  Future<void> updateSortingCriteria(String criteria) async {
    _sortingCriteria = criteria;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sorting_criteria', criteria);
    notifyListeners();
  }

  // Toggle theme mode and save to preferences
  Future<void> toggleThemeMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme_mode', _isDarkMode);
    notifyListeners();
  }

  // Set theme mode directly and save to preferences
  Future<void> setThemeMode(bool isDark) async {
    _isDarkMode = isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme_mode', _isDarkMode);
    notifyListeners();
  }
}
