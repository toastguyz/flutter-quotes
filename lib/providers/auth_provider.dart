import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quotes/utils/sharedprefs_utils.dart';
import 'package:flutter/services.dart' show PlatformException;

class AuthProvider with ChangeNotifier {
  String _userEmail;
  String _userPassword;
  String _userName;

  String get name => _userName;

  String get email => _userEmail;

  String get password => _userPassword;

  Future<bool> isUserAuthenticated() async {
    String email=await SharedPrefs.userEmail;

    return email!=null && email.isNotEmpty;
  }

  Future<void> firebaseLogin(String email, String password) async {
    try {
       await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      _userEmail = email;
      _userPassword = password;

      final userReference = FirebaseDatabase.instance
          .reference()
          .child("Users")
          .limitToFirst(1)
          .orderByChild("userEmail")
          .equalTo(email);

      await userReference.once().then((DataSnapshot snapShot) async {
        /*final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userEmail", _userEmail);
        prefs.setString("userID", _userID);
        prefs.setString("userPassword", _userPassword);*/

        for(var value in snapShot.value.values){
          SharedPrefs.userEmail = _userEmail;
          SharedPrefs.userPassword = _userPassword;

          SharedPrefs.userID = value["userID"];
          SharedPrefs.userName= value["userName"];
          SharedPrefs.userDesignation=value["userDesignation"];
          SharedPrefs.userWebsite=value["userWebsite"];
          SharedPrefs.userContact=value["userContact"];
          SharedPrefs.userPhoto=value["userPhoto"];
        }

        notifyListeners();
      });
    } on PlatformException catch (error) {
      print('Login Catch Error Details: ${error}');

      throw error;
    } catch (error) {
      print('Login Catch Details: $error');

      throw error;
    }
  }

  Future<void> firebaseSignUp(
      String email, String password, String name) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      /*final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userEmail", _userEmail);
      prefs.setString("userID", _userID);
      prefs.setString("userPassword", _userPassword);
      prefs.setString("userName", _userName);
      String firebaseToken = prefs.getString("userToken");*/


      String firebaseToken = await SharedPrefs.userFirebaseToken;
      final userReference = FirebaseDatabase.instance.reference().child("Users");
      String ID= userReference.push().key;
      _userEmail = email;
      _userPassword = password;
      _userName = name;

      await userReference.child(ID).set({
        "userName": _userName,
        "userEmail": _userEmail,
        "userPassword": _userPassword,
        "deviceToken": firebaseToken == null || firebaseToken.isEmpty
            ? ""
            : firebaseToken,
        "updatedAt": DateTime.now().millisecondsSinceEpoch,
        "createdAt": DateTime.now().millisecondsSinceEpoch,
        "userID": ID,
        "userDesignation": "",
        "userWebsite": "",
        "userContact": "",
        "userPhoto": "",
      });

      SharedPrefs.userEmail = _userEmail;
      SharedPrefs.userID = ID;
      SharedPrefs.userPassword = _userPassword;
      SharedPrefs.userName = _userName;

      notifyListeners();
    } on PlatformException catch (error) {
      print('SignUp Catch Error Details: ${error}');

      throw error;
    } catch (error) {
      print('SignUp Catch Details: $error');

      throw error;
    }
  }
}
