

import 'dart:convert';

import 'package:flutter_helper/entity/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil{

  static String rememberCodeApp;


  static void saveUserInfo(UserEntity userEntity) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("remember_code_app", userEntity.rememberCodeApp);
    rememberCodeApp = userEntity.rememberCodeApp;
    print(json.encode(userEntity.data.toJson()));
    sp.setString("user_data", json.encode(userEntity.data.toJson()));
  }

  static Future<String> getRememberCodeApp() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (rememberCodeApp != null && rememberCodeApp.isNotEmpty) {
      return rememberCodeApp;
    }
    return sp.getString("remember_code_app");
  }

  static Future<UserData> getUserData() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String userData = sp.getString("user_data");
    print(json.decode(userData));
    return UserData.fromJson(json.decode(userData));
  }

  static void clearUserInfo() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }



}