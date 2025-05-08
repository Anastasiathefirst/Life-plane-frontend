import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  late SharedPreferences _prefs;

  factory StorageService() => _instance;

  StorageService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Generic bool setter/getter
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool? getBool(String key) => _prefs.getBool(key);

  // Generic string setter/getter
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) => _prefs.getString(key);

  // Full reset — for when life gets messy
  Future<void> clear() async {
    await _prefs.clear();
  }

  // === Specific helpers for clean code ===

  // Welcome screen
  Future<void> setHasSeenWelcome(bool value) async {
    await setBool('hasSeenWelcome', value);
  }

  bool get hasSeenWelcome => getBool('hasSeenWelcome') ?? false;

  // Logged in status
  Future<void> setIsLoggedIn(bool value) async {
    await setBool('isLoggedIn', value);
  }

  bool get isLoggedIn => getBool('isLoggedIn') ?? false;

  // Email
  Future<void> setUserEmail(String value) async {
    await setString('userEmail', value);
  }

  String? get userEmail => getString('userEmail');

  // Phone
  Future<void> setUserPhone(String value) async {
    await setString('userPhone', value);
  }

  String? get userPhone => getString('userPhone');
}
