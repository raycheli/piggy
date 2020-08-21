import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils {
  static savePrefVal(String key, double value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setDouble(key, value);

    print(pref.getDouble(key));
    print('Preference is saved');
  }

  static getPrefVal(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref.getDouble(key));
    return pref.getDouble(key);
  }
}
