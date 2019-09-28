import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quotes/providers/quote_item_provider.dart';
import 'package:flutter_quotes/utils/network_utils.dart';

class QuotesProvider with ChangeNotifier {
  List<QuoteItem> _quoteItems = [];
  var _isLoader = true;

  List<QuoteItem> get quoteItems {
    return [..._quoteItems];
  }

  bool get isLoader => _isLoader;

  Future<List<QuoteItem>> fetchQuotes() async {
    NetworkCheck networkCheck = NetworkCheck();
    networkCheck.checkInternet((isNetworkPresent) async {
      if (!isNetworkPresent) {
        _isLoader=false;
        notifyListeners();
        return null;
      } else {
        try {
          final quoteReference = FirebaseDatabase.instance.reference().child("Quotes").orderByKey();

          await quoteReference.onValue.listen((Event event) async {

            final List<QuoteItem> loadedQuotes = [];
            if (event.snapshot.value != null) {
              for (var value in event.snapshot.value.values) {
                loadedQuotes.add(QuoteItem.fromJson(value));
              }

              if (loadedQuotes.length == 0) {
                _isLoader = false;
              } else {
                _isLoader = true;
              }
            }

            _quoteItems = loadedQuotes;
            notifyListeners();
            return _quoteItems;
          });
        } catch (error) {
          print("error : ${error.toString()}");

          notifyListeners();
          return null;
        }
      }
    });
  }
}
