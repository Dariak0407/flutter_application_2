import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  // Ключи для хранения
  static const String _lastCoefficientsKey = 'last_coefficients';
  static const String _themeModeKey = 'theme_mode';
  static const String _calcCountKey = 'calculation_count';
  static const String _agreementAcceptedKey = 'agreement_accepted';

  // === Методы для коэффициентов ===
  static Future<void> saveLastCoefficients(double a, double b, double c) async {
    final prefs = await SharedPreferences.getInstance();
    final coefficients = '$a,$b,$c';
    await prefs.setString(_lastCoefficientsKey, coefficients);
  }

  static Future<List<double>?> getLastCoefficients() async {
    final prefs = await SharedPreferences.getInstance();
    final coefficientsStr = prefs.getString(_lastCoefficientsKey);
    
    if (coefficientsStr != null) {
      final parts = coefficientsStr.split(',');
      if (parts.length == 3) {
        return [
          double.tryParse(parts[0]) ?? 0,
          double.tryParse(parts[1]) ?? 0,
          double.tryParse(parts[2]) ?? 0,
        ];
      }
    }
    return null;
  }

  // === Методы для счетчика расчетов ===
  static Future<void> incrementCalculationCount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(_calcCountKey) ?? 0;
    await prefs.setInt(_calcCountKey, currentCount + 1);
  }

  static Future<int> getCalculationCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_calcCountKey) ?? 0;
  }

  // === Методы для согласия ===
  static Future<void> saveAgreementStatus(bool accepted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_agreementAcceptedKey, accepted);
  }

  static Future<bool> getAgreementStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_agreementAcceptedKey) ?? false;
  }

  // === Методы для темы ===
  static Future<void> saveThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeModeKey, isDark);
  }

  static Future<bool> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeModeKey) ?? false;
  }

  // === Общие методы ===
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> removeKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
}