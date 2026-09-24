import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  static const _kThemeKey = 'theme_mode';
  static const _kSessionKey = 'has_session';
  static const _kRoleKey = 'selected_role';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? getThemeMode() => _prefs.getString(_kThemeKey);
  Future<void> setThemeMode(String mode) => _prefs.setString(_kThemeKey, mode);

  bool getHasSession() => _prefs.getBool(_kSessionKey) ?? false;
  Future<void> setHasSession(bool value) => _prefs.setBool(_kSessionKey, value);

  String? getSelectedRole() => _prefs.getString(_kRoleKey);
  Future<void> setSelectedRole(String role) => _prefs.setString(_kRoleKey, role);
  Future<void> clearSelectedRole() => _prefs.remove(_kRoleKey);
}
