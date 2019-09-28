import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class QuoteItem with ChangeNotifier {
  String quoteId;
  String quoteAuthor;
  String quoteImage;
  String quoteCategory;
  String quoteDescription;

  QuoteItem(
      {this.quoteId,
      this.quoteAuthor,
      this.quoteImage,
      this.quoteCategory,
      this.quoteDescription});

  QuoteItem.fromJson(var value) {
    this.quoteId = value["quoteId"];
    this.quoteAuthor = value["quoteAuthor"];
    this.quoteImage = value["quoteImage"];
    this.quoteCategory = value["quoteCategory"];
    this.quoteDescription = value["quoteDescription"];
  }

  Future<String> uploadImage(File image) async {
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("quoteImages/${DateTime.now().toIso8601String()}");
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    String storagePath = await taskSnapshot.ref.getDownloadURL();

    Uri finalPath = Uri.parse(storagePath);
    return storagePath;
  }

  Future<void> uploadQuote(File imageFile, QuoteItem quoteItem) async {
    try {
      var imageUrl;
      if (imageFile != null) {
        imageUrl = await uploadImage(imageFile);
      }

      final quoteReference = FirebaseDatabase.instance.reference().child("Quotes");
      String resourceID = quoteReference.push().key;
      if (quoteItem == null || quoteItem.quoteId == null) {
        await quoteReference.child(resourceID).set({
          "quoteId": resourceID,
          "quoteAuthor": quoteItem.quoteAuthor,
          "quoteImage": imageUrl != null && imageUrl.length > 0 ? imageUrl : "",
          "quoteCategory": quoteItem.quoteCategory,
          "quoteDescription": quoteItem.quoteDescription,
        });
      } else {

        await quoteReference.child(quoteItem.quoteId).update({
          "quoteId": quoteItem.quoteId,
          "quoteAuthor": quoteItem.quoteAuthor,
          "quoteImage": imageUrl != null && imageUrl.length > 0
              ? imageUrl
              : quoteItem.quoteImage,
          "quoteCategory": quoteItem.quoteCategory,
          "quoteDescription": quoteItem.quoteDescription,
        });
      }

      notifyListeners();
    } catch (error) {
      print("error : ${error.toString()}");

      throw error;
    }
  }

  Future<void> deleteQuote(String quoteId) async {
    try{
      final quoteReference = FirebaseDatabase.instance.reference().child("Quotes");
      quoteReference.child(quoteId).remove().then((_){
        notifyListeners();
      });

    }catch (error) {
      print("error : ${error.toString()}");

      throw error;
    }
  }
}
