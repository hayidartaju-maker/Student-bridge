import 'package:shared_preferences/shared_preferences.dart';

/// Local, on-device storage only — theme choice and "seen splash before"
/// flags. All real data (students, parents, photos) lives in Supabase via
/// SupabaseService, not here.
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  static const _kThemeKey = 'theme_mode';
  static const _kSessionKey = 'has_session';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? getThemeMode() => _prefs.getString(_kThemeKey);
  Future<void> setThemeMode(String mode) => _prefs.setString(_kThemeKey, mode);

  bool getHasSession() => _prefs.getBool(_kSessionKey) ?? false;
  Future<void> setHasSession(bool value) => _prefs.setBool(_kSessionKey, value);
}
