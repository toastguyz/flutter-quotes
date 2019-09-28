import 'package:flutter/material.dart';
import 'package:flutter_quotes/auth/auth_page.dart';
import 'package:flutter_quotes/pages/quotes_creation.dart';
import 'package:flutter_quotes/pages/quotes_detail.dart';
import 'package:flutter_quotes/pages/user_profile.dart';
import 'package:flutter_quotes/providers/quote_item_provider.dart';
import 'package:flutter_quotes/providers/quotes_provider.dart';
import 'package:flutter_quotes/utils/color_utils.dart';
import 'package:flutter_quotes/utils/sharedprefs_utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class QuotesDashboard extends StatefulWidget {
  static const routeName = "/quotes-dashboard";

  @override
  _QuotesDashboardState createState() => _QuotesDashboardState();
}

class _QuotesDashboardState extends State<QuotesDashboard> {
  var isInit = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  QuotesProvider quotesProvider;
  Future<List<QuoteItem>> quotesList;
  var isLogOutPressed = false;
  var userName = "User";
  var userEmail = "abc@mail.com";

  @override
  void initState() {
    super.initState();

    initialiseUserDetails();
  }

  @override
  Future didChangeDependencies() {
    if (isInit) {
      quotesProvider = Provider.of<QuotesProvider>(context, listen: false);
      quotesList = quotesProvider.fetchQuotes();
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: Colors.transparent,
        ),
        child: Drawer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  drawerBGGradientStartColor,
                  drawerBGGradientEndColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: UnderlineTabIndicator(
                      borderSide:
                          BorderSide(color: Colors.white10, width: 2.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: ClipOval(
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/quote_placeholder.jpg",
                            image:
                                "https://blog.codemagic.io/uploads/2019/05/CM_Flutter-dev-profile_Header.png",
                            fit: BoxFit.cover,
                            height: 70.0,
                            width: 70.0,
                          ),
                          clipBehavior: Clip.antiAlias,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Text(
                          userName,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Text(userEmail,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {},
                  splashColor: Colors.yellow,
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, UserProfile.routeName);
                    },
                    leading: Icon(
                      Icons.perm_identity,
                      color: Colors.white,
                    ),
                    title: Text(
                      "User Profile",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  splashColor: Colors.yellow,
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    leading: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    title: Text("Share App",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                InkWell(
                  splashColor: Colors.yellow,
                  onTap: () {},
                  child: ListTile(
                    onTap: () {
                      if (!isLogOutPressed) {
                        _logOut();
                      }
                    },
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Exit App",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            clipShape(MediaQuery.of(context).size.height, context),
            Container(
              /*height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).size.height / 3,*/
              child: FutureBuilder<List<QuoteItem>>(
                future: quotesList,
                builder: (BuildContext context,
                    AsyncSnapshot<List<QuoteItem>> quotes) {
                  if (quotes.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (quotes.error != null) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Center(
                        child: Text("Something went wrong. Please try again!!"),
                      ),
                    );
                  }

                  if (quotes.connectionState == ConnectionState.done) {
                    return Consumer<QuotesProvider>(
                      builder: (BuildContext context, QuotesProvider quotes,
                          Widget child) {
                        if (quotes.quoteItems != null) {
                          if (quotes.quoteItems.length > 0) {
                            return ListView.builder(
                              padding: EdgeInsets.only(top: 10.0),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: quotes.quoteItems.length,
                              itemBuilder: (BuildContext context, int index) {
                                var quoteItem = quotes.quoteItems[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => QuotesDetail(
                                                  quoteItem: quoteItem,
                                                )));
                                  },
                                  child: Container(
                                    height: 120.0,
                                    margin: EdgeInsets.only(
                                        top: 15.0, bottom: 15.0),
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          height: 120.0,
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                height: 120.0,
                                                margin: EdgeInsets.only(
                                                    left: 60.0,
                                                    right: 20.0,
                                                    bottom: 15.0),
                                                padding: EdgeInsets.only(
                                                    left: 50.0,
                                                    top: 10.0,
                                                    right: 10.0,
                                                    bottom: 20.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.pink[200],
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 10.0,
                                                      offset: Offset(0.0, 20.0),
                                                    ),
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 10.0,
                                                      offset: Offset(1.0, 10.0),
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    quoteItem.quoteDescription,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    maxLines: 4,
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 60.0, right: 20.0),
                                                  height: 30.0,
                                                  width: 150.0,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        dashboardBGGradientEndColor,
                                                        dashboardBGGradientStartColor,
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(20.0),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      quoteItem.quoteCategory,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Hero(
                                          tag: quoteItem.quoteId,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 20.0,
                                                top: 12.0,
                                                bottom: 12.0),
                                            alignment: Alignment.topLeft,
                                            child: ClipOval(
                                              child: FadeInImage(
                                                placeholder: AssetImage(
                                                    "assets/images/transparent_placeholder.png"),
                                                image: quoteItem.quoteImage ==
                                                            null ||
                                                        quoteItem
                                                            .quoteImage.isEmpty
                                                    ? AssetImage(
                                                        "assets/images/transparent_placeholder.png")
                                                    : NetworkImage(
                                                        quoteItem.quoteImage),
                                                fit: BoxFit.cover,
                                                height: 80.0,
                                                width: 80.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            if (quotes.isLoader) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: Center(
                                  child: Text(
                                    "No Data Found!!",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              );
                            }
                          }
                        } else {
                          return Center(
                            child: Text(
                              "Something went wrong. please try again!!",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w500),
                            ),
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent[400],
        heroTag: null,
        onPressed: () {
          Navigator.pushNamed(context, QuotesCreation.routeName);
        },
        child: Icon(
          Icons.format_quote,
          color: Colors.white,
        ),
      ),
    );
  }

  _logOut() async {
    await SharedPrefs.clearPrefs();
    Navigator.pushReplacementNamed(context, AuthPage.routeName);
    isLogOutPressed = !isLogOutPressed;
  }

  Widget clipShape(double _height, BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _height / 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    dashboardBGGradientStartColor,
                    dashboardBGGradientEndColor
                  ],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _height / 3.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    dashboardBGGradientStartColor,
                    dashboardBGGradientEndColor
                  ],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.25,
          child: ClipPath(
            clipper: CustomShapeClipper3(),
            child: Container(
              height: _height / 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    dashboardBGGradientStartColor,
                    dashboardBGGradientEndColor
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 40, right: 40, top: _height / 3),
          child: Material(
            borderRadius: BorderRadius.circular(30.0),
            elevation: 8,
            child: TextFormField(
              cursorColor: dashboardBGGradientStartColor,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                prefixIcon: Icon(Icons.search,
                    color: dashboardBGGradientStartColor, size: 30),
                hintText: "What are you looking for?",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: 10, right: 10, top: MediaQuery.of(context).padding.top + 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },
              ),
              Flexible(
                child: Center(
                  child: Container(
                    height: 40,
                    width: 150.0,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: dashboardTransparentLayerColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "Quotes",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 25,
                height: 25,
              ),
            ],
          ),
        ),
      ],
    );
  }

  initialiseUserDetails() async {
    var name = await SharedPrefs.userName;
    var email = await SharedPrefs.userEmail;

    if (name != null && name.isNotEmpty) {
      userName = name;
    }

    if (email != null && email.isNotEmpty) {
      userEmail = email;
    }

    setState(() {});
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - 120);

    var firstEndPoint = Offset(size.width, 0);
    var firstControlPoint = Offset(size.width * .5, size.height / 1.5);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class CustomShapeClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - 60);

    var firstEndPoint = Offset(size.width, size.height / 2);
    var firstControlPoint = Offset(size.width * 0.5, size.height + 10);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class CustomShapeClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width, size.height / 1.25);
    var firstControlPoint = Offset(size.width * 0.5, size.height + 20);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
