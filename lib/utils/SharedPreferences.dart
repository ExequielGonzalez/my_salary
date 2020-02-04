import 'package:shared_preferences/shared_preferences.dart';

addStringToSharedPreference(String key, String value) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setString(key, value);
}

addIntToSharedPreference(String key, int value) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setInt(key, value);
}

addDoubleToSharedPreference(String key, double value) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setDouble(key, value);
}

addBoolToSharedPreference(String key, bool value) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setBool(key, value);
}

getStringValuesSharedPreference(String key) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //Return String
  String stringValue = sharedPreferences.getString(key) ?? '';
  return stringValue;
}

getBoolValuesSharedPreference(String key) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //Return bool
  bool boolValue = sharedPreferences.getBool(key);
  return boolValue;
}

getIntValuesSharedPreference(String key) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //Return int
  int intValue = sharedPreferences.getInt(key) ?? 0;
  return intValue;
}

getDoubleValuesSharedPreference(String key) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //Return double
  double doubleValue = sharedPreferences.getDouble(key) ?? 0.0;
  return doubleValue;
}

removeValues(String key) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //Remove with a key
  sharedPreferences.remove(key);
}

checkIfKeyIsPresent(String key) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool checkValue = sharedPreferences.containsKey('value');
  return checkValue;
}
