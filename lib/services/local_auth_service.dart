import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthService {
  static const _storage = FlutterSecureStorage();

  // Keys
  static const String _keyUsername   = 'username';
  static const String _keyPassword   = 'password'; // In production, store a HASH instead!
  static const String _keyIsLoggedIn = 'is_logged_in';

  /// Registers a new user (stores credentials locally)
  Future<void> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();

    // Store username in plain SharedPreferences (non-sensitive)
    await prefs.setString(_keyUsername, username);
    // Store password securely (encrypted)
    await _storage.write(key: _keyPassword, value: password);
    // Mark as logged in
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  /// Attempts to log in with given credentials
  Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString(_keyUsername);
    final storedPassword = await _storage.read(key: _keyPassword);

    if (storedUsername == username && storedPassword == password) {
      await prefs.setBool(_keyIsLoggedIn, true);
      return true;
    }
    return false;
  }

  /// Logs out the current user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    // Optionally clear credentials (uncomment if you want to force re‑registration)
    // await prefs.remove(_keyUsername);
    // await _storage.delete(key: _keyPassword);
  }

  /// Checks if user is already logged in (e.g., for app start)
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Retrieves the stored username (optional)
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }
}