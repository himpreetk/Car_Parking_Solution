import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static String sharedPrefUsernameKey = "Username";
  static String sharedPrefUserEmailKey = "UserEmail";
  static String sharedPrefUserGroupKey = "UserGroup";
  static String sharedPrefVehicleNoKey = "VehicleNo";

  static Future<bool> saveNameSharedPreference(String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefUsernameKey, name);
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefUserEmailKey, userEmail);
  }

  static Future<bool> saveUserGroupSharedPreference(String userGroup) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefUserGroupKey, userGroup);
  }

  static Future<String> getNameSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPrefUsernameKey);
  }

  static Future<String> getUserEmailSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPrefUserEmailKey);
  }



  static Future<bool> saveVehicleNoSharedPreference(String userGroup) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefVehicleNoKey, userGroup);
  }


  static Future<String> getVehicleNoSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPrefVehicleNoKey);
  }




}
