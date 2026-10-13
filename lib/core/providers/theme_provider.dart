import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ViewMode { tabView, singlePage }

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = "theme_mode";
  static const String _viewModeKey = "view_mode";

  ThemeMode _themeMode = ThemeMode.dark;
  ViewMode _viewMode = ViewMode.tabView;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  ViewMode get viewMode => _viewMode;
  bool get isSinglePage => _viewMode == ViewMode.singlePage;

  ThemeProvider() {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? true;
    final isSingle = prefs.getBool(_viewModeKey) ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _viewMode = isSingle ? ViewMode.singlePage : ViewMode.tabView;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

  Future<void> toggleViewMode() async {
    _viewMode =
        _viewMode == ViewMode.tabView ? ViewMode.singlePage : ViewMode.tabView;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_viewModeKey, isSinglePage);
  }
}
