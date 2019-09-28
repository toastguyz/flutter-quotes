import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quotes/providers/quote_item_provider.dart';
import 'package:flutter_quotes/utils/network_utils.dart';
import 'package:flutter_quotes/utils/color_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class QuotesCreation extends StatefulWidget {
  static const routeName = "/quotes-creation";
  final String title;
  final QuoteItem quoteItem;
  final bool isFromEdit;

  QuotesCreation(this.title, {this.quoteItem,this.isFromEdit=false});

  @override
  _QuotesCreationState createState() => _QuotesCreationState();
}

class _QuotesCreationState extends State<QuotesCreation> {
  static var categories = [
    "Anger",
    "Art",
    "Attitude",
    "Birthday",
    "Change",
    "Cool",
    "Courage",
    "Dreams",
    "Education",
    "Failure",
    "Family",
    "Freindship",
    "Funny",
    "History",
    "Happiness",
    "Knowledge",
    "Love",
    "Motivation",
    "Peace",
    "Respect",
    "Trust",
    "War",
    "Work",
  ];

  String selectedCategory = categories[0];
  File _imageFile;

  var isLoading = false;
  var isEditInitialised = true;

  TextEditingController _authorController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void didChangeDependencies() {
    if (widget.quoteItem != null) {
      if (isEditInitialised) {
        _authorController.text = widget.quoteItem.quoteAuthor;
        _descriptionController.text = widget.quoteItem.quoteDescription;
        if(categories.contains(widget.quoteItem.quoteCategory)){
          selectedCategory=widget.quoteItem.quoteCategory;
        }
        isEditInitialised = false;
      }
    }

    super.didChangeDependencies();
  }

  _submitQuotePost(BuildContext context) async {
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
          isLoading = true;
        });

        try {
          await Provider.of<QuoteItem>(context, listen: false).uploadQuote(
              _imageFile,
              QuoteItem(
                quoteId: widget.isFromEdit ? widget.quoteItem.quoteId : null,
                  quoteAuthor: _authorController.text,
                  quoteImage: widget.isFromEdit ? widget.quoteItem.quoteImage : null,
                  quoteCategory: selectedCategory,
                  quoteDescription: _descriptionController.text));

          setState(() {
            isLoading = false;
          });

          Navigator.of(context).pop();
        } catch (error) {
          print("error : ${error.toString()}");

          setState(() {
            isLoading = false;
          });

          final snackBar = SnackBar(content: Text("Something went wrong. Please try again!!"));
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: quoteCreationPrimaryDarkColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(color: quoteCreationPrimaryDarkColor),
        ),
        actions: <Widget>[
          isLoading
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              : IconButton(
                  onPressed: () {
                    _submitQuotePost(context);
                  },
                  icon: Icon(
                    Icons.done,
                    color: quoteCreationPrimaryDarkColor,
                  ),
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                height: 120.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _openImagePicker(context);
                      },
                      child: Container(
                        height: 120.0,
                        width: 120.0,
                        padding: EdgeInsets.only(
                            left: 10.0, right: 5.0, top: 5.0, bottom: 5.0),
                        child: Stack(
                          children: <Widget>[
                            ClipOval(
                              child: _imageFile != null
                                  ? Image.file(
                                      _imageFile,
                                      height: 120.0,
                                      width: 120.0,
                                      fit: BoxFit.fill,
                                    )
                                  : widget.quoteItem != null &&
                                          widget.quoteItem.quoteImage != null &&
                                          widget.quoteItem.quoteImage.length > 0
                                      ? Image.network(
                                          widget.quoteItem.quoteImage,
                                          height: 120.0,
                                          width: 120.0,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.asset(
                                          "assets/images/transparent_placeholder.png",
                                          height: 120.0,
                                          width: 120.0,
                                          fit: BoxFit.fill,
                                        ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              margin: EdgeInsets.only(bottom: 2.0, right: 8.0),
                              child: Icon(
                                Icons.add_circle,
                                color: quoteCreationPrimarycolor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.only(left: 5.0, right: 10.0, top: 5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 5.0),
                              child: TextFormField(
                                controller: _authorController,
                                cursorColor: quoteCreationPrimarycolor,
                                validator: (author) {
                                  if (author.isEmpty) {
                                    return "Author name is required.";
                                  }
                                },
                                style: TextStyle(
                                    color: quoteCreationPrimaryDarkColor),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  hintText: "Author Name",
                                  filled: true,
                                  fillColor: textFormFieldFillColor,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                            Container(
                              height: 45.0,
                              child: Card(
                                elevation: 5.0,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    isDense: true,
                                    onChanged: (valueSelectedByUser) {
                                      setState(() {
                                        selectedCategory = valueSelectedByUser;
                                      });
                                    },
                                    items:
                                        categories.map((String dropDownItem) {
                                      return DropdownMenuItem<String>(
                                        value: dropDownItem,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            dropDownItem,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color:
                                                    quoteCreationPrimaryDarkColor),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    value: selectedCategory,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: TextFormField(
                  controller: _descriptionController,
                  cursorColor: quoteCreationPrimarycolor,
                  maxLines: 10,
                  validator: (description) {
                    if (description.isEmpty) {
                      return "Quote description is required.";
                    }
                  },
                  style: TextStyle(color: quoteCreationPrimaryDarkColor),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: textFormFieldFillColor,
                    contentPadding: EdgeInsets.all(20),
                    hintText: "Quote Description...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          /*String filePath = image.path;
          Uri fileURI = image.uri;*/
        });
      }
    });
  }
}
