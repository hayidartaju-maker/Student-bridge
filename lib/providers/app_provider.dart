import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/supabase_service.dart';

class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _hasSession = false;

  ThemeMode get themeMode => _themeMode;
  bool get hasSession => _hasSession;
  bool get isLoggedIn => SupabaseService.instance.isLoggedIn;

  Future<void> loadTheme() async {
    final saved = StorageService.instance.getThemeMode();
    _themeMode = saved == 'dark' ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await StorageService.instance.setThemeMode(
      _themeMode == ThemeMode.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }

  Future<void> loadSession() async {
    _hasSession = StorageService.instance.getHasSession();
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    await SupabaseService.instance.signIn(email, password);
    _hasSession = true;
    await StorageService.instance.setHasSession(true);
    notifyListeners();
  }

  Future<void> signOut() async {
    await SupabaseService.instance.signOut();
    _hasSession = false;
    await StorageService.instance.setHasSession(false);
    notifyListeners();
  }
}
