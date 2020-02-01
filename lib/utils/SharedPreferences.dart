import 'package:shared_preferences/shared_preferences.dart';

addStringToSharedPreference(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

addIntToSharedPreference(String key, int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(key, value);
}

addDoubleToSharedPreference(String key, double value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble(key, value);
}

addBoolToSharedPreference(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
}

getStringValuesSharedPreference(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString(key) ?? '';
  return stringValue;
}

getBoolValuesSharedPreference(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return bool
  bool boolValue = prefs.getBool(key);
  return boolValue;
}

getIntValuesSharedPreference(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return int
  int intValue = prefs.getInt(key) ?? 0;
  return intValue;
}

getDoubleValuesSharedPreference(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return double
  double doubleValue = prefs.getDouble(key) ?? 0.0;
  return doubleValue;
}

removeValues(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Remove with a key
  prefs.remove(key);
}

checkIfKeyIsPresent(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool checkValue = prefs.containsKey('value');
  return checkValue;
}
