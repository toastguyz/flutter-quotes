import 'package:flutter/material.dart';
import 'package:flutter_quotes/pages/quotes_dashboard.dart';
import 'package:flutter_quotes/providers/auth_provider.dart';
import 'package:flutter_quotes/utils/network_utils.dart';
import 'package:flutter_quotes/utils/color_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show PlatformException;

class AuthPage extends StatefulWidget {
  static const routeName = "/auth-page";

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode mFocusNodePassword = FocusNode();
  final FocusNode mFocusNodeEmail = FocusNode();
  final FocusNode mFocusNodeName = FocusNode();

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfirmPasswordController =
  TextEditingController();

  PageController _pageController = PageController(initialPage: 0);
  GlobalKey<FormState> _loginFormKey = GlobalKey();
  GlobalKey<FormState> _signUpFormKey = GlobalKey();
  var isLoginAuthenticating = false;
  var isSignUpAuthenticating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _buildAuthPage()),
    );
  }

  _submitLoginForm(BuildContext context) async {
    if (!_loginFormKey.currentState.validate()) {
      return;
    }

    NetworkCheck networkCheck = NetworkCheck();
    networkCheck.checkInternet((isNetworkPresent) async {
      if (!isNetworkPresent) {
        final snackBar = SnackBar(content: Text("Please check your internet connection !!"));

        Scaffold.of(context).showSnackBar(snackBar);
        return;
      } else {
        setState(() {
          isLoginAuthenticating = true;
        });

        try {
          await Provider.of<AuthProvider>(context, listen: false)
              .firebaseLogin(
              loginEmailController.text, loginPasswordController.text);

          setState(() {
            isLoginAuthenticating = false;
          });

          Navigator.pushReplacementNamed(context, QuotesDashboard.routeName);
        }
        on PlatformException catch(error){
          print("PlatformException error : ${error.toString()}");

          setState(() {
            isLoginAuthenticating = false;
          });

          final snackBar = SnackBar(content: Text(error.message));
          Scaffold.of(context).showSnackBar(snackBar);
        } catch (error) {
          print("error : ${error.toString()}");

          setState(() {
            isLoginAuthenticating = false;
          });

          final snackBar = SnackBar(content: Text("Something went wrong. Please try again!!"));
          Scaffold.of(context).showSnackBar(snackBar);
        }
      }
    });
  }

  _submitSignUpForm(BuildContext context) async {
    if (!_signUpFormKey.currentState.validate()) {
      return;
    }

    NetworkCheck networkCheck = NetworkCheck();
    networkCheck.checkInternet((isNetworkPresent) async {
      if (!isNetworkPresent) {
        final snackBar =
        SnackBar(content: Text("Please check your internet connection !!"));

        Scaffold.of(context).showSnackBar(snackBar);
        return;
      } else {
        setState(() {
          isSignUpAuthenticating = true;
        });

        try {
          await Provider.of<AuthProvider>(context, listen: false).firebaseSignUp(
              signupEmailController.text,
              signupPasswordController.text,
              signupNameController.text);

          setState(() {
            isSignUpAuthenticating = false;
          });

          Navigator.pushReplacementNamed(context, QuotesDashboard.routeName);
        }on PlatformException catch(error){
          print("PlatformException error : ${error.toString()}");

          setState(() {
            isSignUpAuthenticating = false;
          });

          final snackBar = SnackBar(content: Text(error.message));
          Scaffold.of(context).showSnackBar(snackBar);
        }  catch (error) {
          print("error : ${error.toString()}");

          setState(() {
            isSignUpAuthenticating = false;
          });

          final snackBar = SnackBar(content: Text("Something went wrong. Please try again!!"));
          Scaffold.of(context).showSnackBar(snackBar);
        }
      }
    });
  }

  Widget _buildAuthPage() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [authBGGradientStartColor, authBGGradientEndColor],
              stops: [0.6, 1.0],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        PageView.builder(
          itemCount: 2,
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _buildSignIn(context);
            } else {
              return _buildSignUp(context);
            }
          },
        ),
      ],
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 60.0,
                child: Center(
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(
                        fontSize: 30.0,
                        letterSpacing: 1.5,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Card(
                    elevation: 2.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      width: 300.0,
                      height: 340.0,
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: Form(
                        key: _signUpFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 15.0,
                                  left: 25.0,
                                  right: 25.0),
                              child: TextFormField(
                                focusNode: mFocusNodeName,
                                controller: signupNameController,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                  hintText: "Name",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0),
                                ),
                                validator: (String name) {
                                  if (name.isEmpty) {
                                    return 'valid name is required.';
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 0.0,
                                  bottom: 15.0,
                                  left: 25.0,
                                  right: 25.0),
                              child: TextFormField(
                                focusNode: mFocusNodeEmail,
                                controller: signupEmailController,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.email,
                                    color: Colors.black,
                                  ),
                                  hintText: "Email Address",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0),
                                ),
                                validator: (String email) {
                                  if (email.isEmpty ||
                                      !RegExp(
                                          r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                          .hasMatch(email)) {
                                    return 'valid email is required.';
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 0.0,
                                  bottom: 15.0,
                                  left: 25.0,
                                  right: 25.0),
                              child: TextFormField(
                                focusNode: mFocusNodePassword,
                                controller: signupPasswordController,
                                obscureText: _obscureTextSignup,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.black,
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      _obscureTextSignup = !_obscureTextSignup;
                                    },
                                    child: Icon(
                                      _obscureTextSignup
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                validator: (String password) {
                                  if (password.isEmpty && password.length < 4) {
                                    return 'valid password is required.';
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 0.0,
                                  bottom: 15.0,
                                  left: 25.0,
                                  right: 25.0),
                              child: TextFormField(
                                controller: signupConfirmPasswordController,
                                obscureText: _obscureTextSignupConfirm,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.black,
                                  ),
                                  hintText: "Confirmation",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      _obscureTextSignupConfirm =
                                      !_obscureTextSignupConfirm;
                                    },
                                    child: Icon(
                                      _obscureTextSignupConfirm
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return "confirmation is required.";
                                  }
                                  if (signupPasswordController.text != value) {
                                    return 'passwords do not match.';
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 340.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: authBGGradientStartColor,
                          offset: Offset(1.0, 6.0),
                          blurRadius: 20.0,
                        ),
                        BoxShadow(
                          color: authBGGradientEndColor,
                          offset: Offset(1.0, 6.0),
                          blurRadius: 20.0,
                        ),
                      ],
                      gradient: LinearGradient(
                          colors: [
                            authBGGradientStartColor,
                            authBGGradientEndColor
                          ],
                          begin: FractionalOffset(0.2, 0.2),
                          end: FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: MaterialButton(
                      highlightColor: authButtonHighlightColor,
                      splashColor: authButtonsplashColor,
                      child: isSignUpAuthenticating
                          ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 60.0),
                          child: CircularProgressIndicator())
                          : Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 42.0),
                        child: Text(
                          "SIGN UP",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      onPressed: () {
                        if (!isSignUpAuthenticating) {
                          _submitSignUpForm(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: FlatButton(
                  onPressed: () {
                    _pageController.animateToPage(0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: Text(
                    "Wanna SignIn?",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 100.0,
                child: Center(
                  child: Text(
                    "SIGN IN",
                    style: TextStyle(
                        fontSize: 30.0,
                        letterSpacing: 1.5,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Card(
                    elevation: 2.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      width: 300.0,
                      height: 200.0,
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Form(
                        key: _loginFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 20.0,
                                  left: 25.0,
                                  right: 25.0),
                              child: TextFormField(
                                focusNode: myFocusNodeEmailLogin,
                                controller: loginEmailController,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.email,
                                    color: Colors.black,
                                    size: 22.0,
                                  ),
                                  hintText: "Email Address",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17.0),
                                ),
                                validator: (String email) {
                                  if (email.isEmpty ||
                                      !RegExp(
                                          r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                          .hasMatch(email)) {
                                    return "valid email is required.";
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 0.0,
                                  bottom: 20.0,
                                  left: 25.0,
                                  right: 25.0),
                              child: TextFormField(
                                focusNode: myFocusNodePasswordLogin,
                                controller: loginPasswordController,
                                obscureText: _obscureTextLogin,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.lock,
                                    size: 22.0,
                                    color: Colors.black,
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17.0),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      _obscureTextLogin = !_obscureTextLogin;
                                    },
                                    child: Icon(
                                      _obscureTextLogin
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                validator: (String password) {
                                  if (password.isEmpty && password.length < 4) {
                                    return "valid password is required.";
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 190.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: authBGGradientStartColor,
                          offset: Offset(1.0, 6.0),
                          blurRadius: 20.0,
                        ),
                        BoxShadow(
                          color: authBGGradientEndColor,
                          offset: Offset(1.0, 6.0),
                          blurRadius: 20.0,
                        ),
                      ],
                      gradient: LinearGradient(
                          colors: [
                            authBGGradientStartColor,
                            authBGGradientEndColor
                          ],
                          begin: const FractionalOffset(0.2, 0.2),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: MaterialButton(
                      highlightColor: authButtonHighlightColor,
                      splashColor: authButtonsplashColor,
                      child: isLoginAuthenticating
                          ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 60.0),
                          child: CircularProgressIndicator())
                          : Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 42.0),
                        child: Text(
                          "SIGN IN",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      onPressed: () {
                        if (!isLoginAuthenticating) {
                          _submitLoginForm(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: FlatButton(
                  onPressed: () {
                    _pageController.animateToPage(1,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: Text(
                    "Wanna SignUp?",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

var primaryGradient = LinearGradient(
  colors: [authBGGradientStartColor, authBGGradientEndColor],
  stops: [0.0, 1.0],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

/*checkInternetConnectivity().then((isNetworkPresent){
      if (!isNetworkPresent) {
        final snackBar =SnackBar(content: Text('Please check your internet connection !!'));

        Scaffold.of(context).showSnackBar(snackBar);
        return;
      } else {
        setState(() {
          isLoginAuthenticating = true;
        });
      }
    });*/
