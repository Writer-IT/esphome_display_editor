import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static late SharedPreferences _prefs;
  static const String _espCodeKey = 'saved_esp_code';

  static Future<void> saveEspCode({String code}) async {
    await _prefs.setString(_espCodeKey, code);
  }
}
