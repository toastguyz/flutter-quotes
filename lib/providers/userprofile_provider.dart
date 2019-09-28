import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quotes/utils/sharedprefs_utils.dart';

class UserProfileProvider with ChangeNotifier {

  Future<void> updateProfile(
      String ID,
      String userDesignation,
      String userWebsite,
      String userContact,
      String userPhoto,
      File imageFile) async {
    try {
      var imageUrl;
      if (imageFile != null) {
        imageUrl = await uploadImage(imageFile);
      } else {
        imageUrl = userPhoto;
      }

      final userReference = FirebaseDatabase.instance.reference().child("Users");
      await userReference.child(ID).update({
        "userDesignation": userDesignation,
        "userWebsite": userWebsite,
        "userContact": userContact,
        "userPhoto": imageUrl,
      });

      SharedPrefs.userDesignation=userDesignation;
      SharedPrefs.userWebsite=userWebsite;
      SharedPrefs.userContact=userContact;
      SharedPrefs.userPhoto=imageUrl;

      notifyListeners();
    } catch (error) {
      print("error : ${error.toString()}");

      throw error;
    }
  }

  Future<String> uploadImage(File image) async {
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("userProfiles/${DateTime.now().toIso8601String()}");
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    String storagePath = await taskSnapshot.ref.getDownloadURL();
    return storagePath;
  }
}
