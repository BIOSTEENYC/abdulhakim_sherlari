import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextSettingsProvider with ChangeNotifier {
  double _fontSize = 16.0;
  String _fontFamily = 'Roboto';

  double get fontSize => _fontSize;
  String get fontFamily => _fontFamily;

  TextSettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getDouble('fontSize') ?? 16.0;
    _fontFamily = prefs.getString('fontFamily') ?? 'Roboto';
    notifyListeners();
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', size);
    notifyListeners();
  }

  Future<void> setFontFamily(String family) async {
    _fontFamily = family;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fontFamily', family);
    notifyListeners();
  }
}