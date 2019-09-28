import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quotes/providers/userprofile_provider.dart';
import 'package:flutter_quotes/utils/color_utils.dart';
import 'package:flutter_quotes/utils/network_utils.dart';
import 'package:flutter_quotes/utils/sharedprefs_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  static const routeName = "/user-profile";

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var isUpdating = false;
  var isEditMode = false;
  var userPhoto = "";

  var userName = "User";
  var userEmail = "abc@mail.com";
  var userWebsite = "-";
  var userDesignation = "-";
  var userContact = "-";

  TextEditingController designationController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  File _imageFile;
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    initialiseUserDetails();
  }

  initialiseUserDetails() async {
    var name = await SharedPrefs.userName;
    var email = await SharedPrefs.userEmail;
    var website = await SharedPrefs.userWebsite;
    var designation = await SharedPrefs.userDesignation;
    var contact = await SharedPrefs.userContact;
    var photo = await SharedPrefs.userPhoto;

    if (name != null && name.isNotEmpty) {
      userName = name;
    }

    if (email != null && email.isNotEmpty) {
      userEmail = email;
    }

    if (website != null && website.isNotEmpty) {
      userWebsite = website;
      websiteController.text = website;
    }

    if (designation != null && designation.isNotEmpty) {
      userDesignation = designation;
      designationController.text = designation;
    }

    if (contact != null && contact.isNotEmpty) {
      userContact = contact;
      contactController.text = contact;
    }

    if (photo != null && photo.isNotEmpty) {
      userPhoto = photo;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var curveHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            CustomPaint(
              painter: CustomClipShadowPainter(
                clipper: CustomCurveClipper(),
                shadow: BoxShadow(
                    color: Colors.blueGrey,
                    blurRadius: 10,
                    offset: Offset(1, 1)),
              ),
              child: ClipPath(
                clipper: CustomCurveClipper(),
                child: Container(
                  height: curveHeight / 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        profileViewGradientStartColor,
                        profileViewGradientMidColor,
                        profileViewGradientEndColor
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                      left: 5.0,
                      right: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      isEditMode
                          ? Container()
                          : IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.white,
                              onPressed: () {
                                setState(() {
                                  isEditMode = true;
                                });
                              },
                            ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (isEditMode) {
                      _openImagePicker(context);
                    }
                    ;
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    width: MediaQuery.of(context).size.height * 0.25,
                    height: MediaQuery.of(context).size.height * 0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _imageFile != null
                            ? FileImage(_imageFile)
                            : userPhoto != null && userPhoto.isNotEmpty
                                ? NetworkImage(userPhoto)
                                : AssetImage(
                                    'assets/images/quote_placeholder.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * 0.15,
                      ),
                      border: Border.all(
                        color: Colors.white,
                        width: 5.0,
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    userName,
                    style: TextStyle(
                        color: quoteCreationPrimarycolor,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  child: Text(
                    userEmail,
                    style: TextStyle(
                        color: quoteCreationPrimarycolor, fontSize: 15.0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                isEditMode ? _buildFormFields() : _buildDisplayFields(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplayFields() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
              child: FloatingActionButton(
                heroTag: null,
                mini: true,
                onPressed: () {},
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.whatshot,
                  color: Colors.blue,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Designation",
                    style: TextStyle(color: Colors.grey, fontSize: 10.0),
                  ),
                  Text(
                    userDesignation,
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
              child: FloatingActionButton(
                heroTag: null,
                mini: true,
                onPressed: () {},
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.link,
                  color: Colors.red,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Website",
                    style: TextStyle(color: Colors.grey, fontSize: 10.0),
                  ),
                  Text(
                    userWebsite,
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
              child: FloatingActionButton(
                heroTag: null,
                mini: true,
                onPressed: () {},
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.phone,
                  color: Colors.green,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Contact",
                    style: TextStyle(color: Colors.grey, fontSize: 10.0),
                  ),
                  Text(
                    userContact,
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: TextFormField(
              controller: designationController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[50],
                labelText: "Designation",
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (designation) {
                if (designation.isEmpty) {
                  return "Designation is required!!";
                }
              },
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextFormField(
              controller: websiteController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[50],
                labelText: "Website",
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (website) {
                if (website.isEmpty) {
                  return "Website is required!!";
                }
              },
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: TextFormField(
              controller: contactController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[50],
                labelText: "Contact",
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (contact) {
                if (contact.isEmpty) {
                  return "Contact is required!!";
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: isUpdating
                ? Center(child: CircularProgressIndicator())
                : RaisedButton(
                    color: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    onPressed: () {
                      _updateProfile();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 50.0),
                      child: Text(
                        "Update Profile",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  _updateProfile() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    NetworkCheck networkCheck = NetworkCheck();
    networkCheck.checkInternet((isNetworkPresent) async {
      if (!isNetworkPresent) {
        final snackBar =
            SnackBar(content: Text("Please check your internet connection !!"));

        _scaffoldKey.currentState.showSnackBar(snackBar);
        return;
      } else {
        setState(() {
          isUpdating = true;
        });

        try {
          var ID = await SharedPrefs.userID;
          await Provider.of<UserProfileProvider>(context, listen: false)
              .updateProfile(
                  ID,
                  designationController.text,
                  websiteController.text,
                  contactController.text,
                  userPhoto,
                  _imageFile);

          setState(() {
            isUpdating = false;
            isEditMode = false;
          });

          Navigator.of(context).pop();
        } catch (error) {
          setState(() {
            isUpdating = false;
          });

          final snackBar = SnackBar(
              content: Text("Something went wrong. Please try again!!"));
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      }
    });
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    "Select Image",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: quoteCreationPrimarycolor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    _getImage(context, ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.photo_camera,
                        size: 30.0,
                        color: quoteCreationPrimarycolor,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                      ),
                      Text(
                        "Use Camera",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: quoteCreationPrimarycolor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    _getImage(context, ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.camera,
                        size: 30.0,
                        color: quoteCreationPrimarycolor,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                      ),
                      Text(
                        "Use Gallery",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: quoteCreationPrimarycolor,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  _getImage(BuildContext context, ImageSource source) async {
    ImagePicker.pickImage(
      source: source,
      maxWidth: 400.0,
      maxHeight: 400.0,
    ).then((File image) async {
      if (image != null) {
        setState(() {
          _imageFile = image;
        });
      }
    });
  }
}

class CustomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.lineTo(0.0, size.height - size.height / 2);
    path.lineTo(
        size.width - size.width * 0.85, size.height - size.height * 0.25);
    path.lineTo(size.width, size.height - size.height * 0.8);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class CustomClipShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  CustomClipShadowPainter({@required this.shadow, @required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
