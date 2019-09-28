import 'package:flutter/material.dart';
import 'package:flutter_quotes/auth/auth_page.dart';
import 'package:flutter_quotes/pages/quotes_creation.dart';
import 'package:flutter_quotes/pages/quotes_dashboard.dart';
import 'package:flutter_quotes/pages/user_profile.dart';
import 'package:flutter_quotes/providers/auth_provider.dart';
import 'package:flutter_quotes/providers/quote_item_provider.dart';
import 'package:flutter_quotes/providers/quotes_provider.dart';
import 'package:flutter_quotes/providers/userprofile_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProvider(
          builder: (BuildContext context) => QuoteItem(),
        ),
        ChangeNotifierProvider(
          builder: (BuildContext context) => QuotesProvider(),
        ),
        ChangeNotifierProvider(
          builder: (BuildContext context) => UserProfileProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (BuildContext context, AuthProvider auth, Widget child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Quotes',
            theme: ThemeData(
              fontFamily: "Lato",
              primarySwatch: Colors.blue,
            ),
            home: FutureBuilder<bool>(
                future: auth.isUserAuthenticated(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.data != null && snapshot.data) {
                    return QuotesDashboard();
                  } else {
                    return AuthPage();
                  }
                }),
            routes: {
              AuthPage.routeName: (context) => AuthPage(),
              QuotesDashboard.routeName: (context) => QuotesDashboard(),
              QuotesCreation.routeName: (context) => QuotesCreation("Create a Quote"),
              UserProfile.routeName: (context) => UserProfile(),
            },
          );
        },
      ),
    );
  }
}
