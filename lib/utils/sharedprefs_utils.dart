import 'package:shared_preferences/shared_preferences.dart';

import 'preference_helper.dart';

const String USER_ID = "app_userID";
const String USER_NAME = "app_userName";
const String USER_PHOTO = "app_userPhoto";
const String USER_EMAIL = "app_userEmail";
const String USER_WEBSITE = "app_userWebsite";
const String USER_DESIGNATION = "app_userDesignation";
const String USER_CONTACT = "app_userContact";
const String USER_PASSWORD = "app_userPassword";
const String USER_FIREBASE_TOKEN = "app_userFirebaseToken";

class SharedPrefs {
  static Future<String> get userID =>
      PreferencesHelper.getString(USER_ID);

  static set userID(String value) =>
      PreferencesHelper.setString(USER_ID, value);

  static Future<String> get userName =>
      PreferencesHelper.getString(USER_NAME);

  static set userName(String value) =>
      PreferencesHelper.setString(USER_NAME, value);

  static Future<String> get userPhoto =>
      PreferencesHelper.getString(USER_PHOTO);

  static set userPhoto(String value) =>
      PreferencesHelper.setString(USER_PHOTO, value);

  static Future<String> get userEmail =>
      PreferencesHelper.getString(USER_EMAIL);

  static set userEmail(String value) =>
      PreferencesHelper.setString(USER_EMAIL, value);

  static Future<String> get userWebsite =>
      PreferencesHelper.getString(USER_WEBSITE);

  static set userWebsite(String value) =>
      PreferencesHelper.setString(USER_WEBSITE, value);

  static Future<String> get userDesignation =>
      PreferencesHelper.getString(USER_DESIGNATION);

  static set userDesignation(String value) =>
      PreferencesHelper.setString(USER_DESIGNATION, value);

  static Future<String> get userContact =>
      PreferencesHelper.getString(USER_CONTACT);

  static set userContact(String value) =>
      PreferencesHelper.setString(USER_CONTACT, value);

  static Future<String> get userPassword =>
      PreferencesHelper.getString(USER_PASSWORD);

  static set userPassword(String value) =>
      PreferencesHelper.setString(USER_PASSWORD, value);

  static Future<String> get userFirebaseToken =>
      PreferencesHelper.getString(USER_FIREBASE_TOKEN);

  static set userFirebaseToken(String value) =>
      PreferencesHelper.setString(USER_FIREBASE_TOKEN, value);

  static clearPrefs() async{
    SharedPreferences prefs=await PreferencesHelper.sharedPrefs;
    prefs.clear();
  }
}
