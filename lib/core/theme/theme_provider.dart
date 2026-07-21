import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared_providers/supabase_providers.dart';

const _themeModeKey = 'theme_mode';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._prefs) : super(_read(_prefs));

  final SharedPreferences _prefs;

  static ThemeMode _read(SharedPreferences prefs) {
    switch (prefs.getString(_themeModeKey)) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void set(ThemeMode mode) {
    state = mode;
    _prefs.setString(_themeModeKey, mode.name);
  }

  void toggle() =>
      set(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier(ref.watch(sharedPreferencesProvider));
});
