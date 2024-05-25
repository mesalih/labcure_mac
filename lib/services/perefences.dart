import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModes { light, dark }

class Preferences extends ChangeNotifier {
  static final Preferences _instance = Preferences._internal();
  factory Preferences() => _instance;
  Preferences._internal();

  static Future<void> ensureInitialized() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? index = prefs.getInt(Pref.theme) ?? 0;
    ThemeModes value = ThemeModes.values[index];
    _instance.setTheme(value);
  }

  ThemeModes? theme;

  Future<void> setTheme(ThemeModes value) async {
    theme = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(Pref.theme, value.index);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    theme = theme == ThemeModes.dark ? ThemeModes.light : ThemeModes.dark;
    await setTheme(theme!);
  }
}

class Pref {
  static const String theme = 'theme';
}
