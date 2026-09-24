import 'package:flutter/material.dart';
import '../core/app_roles.dart';
import '../services/storage_service.dart';
import '../services/supabase_service.dart';

class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _hasSession = false;
  AppRole? _selectedRole;

  ThemeMode get themeMode => _themeMode;
  bool get hasSession => _hasSession;
  AppRole? get selectedRole => _selectedRole;
  bool get isLoggedIn => SupabaseService.instance.isLoggedIn;

  Future<void> loadTheme() async {
    _themeMode = StorageService.instance.getThemeMode() == 'dark'
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    await StorageService.instance.setThemeMode(
      _themeMode == ThemeMode.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }

  Future<void> loadSession() async {
    _hasSession = StorageService.instance.getHasSession();
    notifyListeners();
  }

  Future<void> loadRole() async {
    _selectedRole = AppRoleExtension.fromValue(
      StorageService.instance.getSelectedRole(),
    );
    notifyListeners();
  }

  Future<void> setRole(AppRole role) async {
    _selectedRole = role;
    await StorageService.instance.setSelectedRole(role.value);
    notifyListeners();
  }

  Future<void> clearRole() async {
    _selectedRole = null;
    await StorageService.instance.clearSelectedRole();
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
    await clearRole();
    notifyListeners();
  }
}
