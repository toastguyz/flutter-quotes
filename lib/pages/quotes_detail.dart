import 'package:flutter/material.dart';
import 'package:flutter_quotes/pages/quotes_creation.dart';
import 'package:flutter_quotes/providers/quote_item_provider.dart';
import 'package:flutter_quotes/utils/color_utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class QuotesDetail extends StatefulWidget {
  final QuoteItem quoteItem;

  QuotesDetail({this.quoteItem});

  @override
  _QuotesDetailState createState() => _QuotesDetailState();
}

class _QuotesDetailState extends State<QuotesDetail> {
  var isDeleting = false;

  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Warning !!!",
        style: TextStyle(color: dialogPrimaryColor),
      ),
      content: Text("Are you sure want to delete this quote?"),
      actions: [
        FlatButton(
          child: Text("NO", style: TextStyle(color: dialogPrimaryColor)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(
            "YES",
            style: TextStyle(color: dialogPrimaryColor),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            deleteQuote();
          },
        )
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  deleteQuote() async {
    setState(() {
      isDeleting = true;
    });

    try {
      await Provider.of<QuoteItem>(context, listen: false)
          .deleteQuote(widget.quoteItem.quoteId);

      setState(() {
        isDeleting = false;
      });
      Navigator.of(context).pop();
    } catch (error) {
      setState(() {
        isDeleting = false;
      });
      final snackBar =
          SnackBar(content: Text("Something went wrong. Please try again!!"));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.quoteItem.quoteId,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: FadeInImage(
                placeholder: AssetImage("assets/images/quote_placeholder.jpg"),
                image: widget.quoteItem.quoteImage == null ||
                        widget.quoteItem.quoteImage.isEmpty
                    ? AssetImage("assets/images/quote_placeholder.jpg")
                    : NetworkImage(widget.quoteItem.quoteImage),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            color: Colors.black12.withOpacity(0.1),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuotesCreation(
                              "Edit a Quote",
                              quoteItem: widget.quoteItem,
                              isFromEdit: true,
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    isDeleting
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              showAlertDialog(context);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.44),
            child: Shimmer.fromColors(
              direction: ShimmerDirection.rtl,
              period: Duration(seconds: 2),
              highlightColor: shimmerHighlightColor,
              baseColor: shimmerBaseColor,
              child: Text(
                widget.quoteItem.quoteAuthor,
                style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    quoteDetailGradientStartColor,
                    quoteDetailGradientEndColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Color(0xFF3A5160).withOpacity(0.5),
                      offset: Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Container(
                margin: EdgeInsets.only(bottom: 10.0),
                padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(0.0),
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                      child: Center(
                        child: Shimmer.fromColors(
                          direction: ShimmerDirection.rtl,
                          period: Duration(seconds: 2),
                          highlightColor: shimmerHighlightColor,
                          baseColor: shimmerBaseColor,
                          child: Text(
                            widget.quoteItem.quoteCategory,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        widget.quoteItem.quoteDescription,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*Align(
alignment: Alignment.bottomCenter,
child: Container(
height: MediaQuery.of(context).size.height * 0.5,
decoration: BoxDecoration(
gradient: LinearGradient(
colors: [
quoteDetailGradientStartColor,
quoteDetailGradientEndColor,
],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
color: Colors.white,
borderRadius: BorderRadius.only(
topLeft: Radius.circular(30.0),
topRight: Radius.circular(30.0)),
boxShadow: <BoxShadow>[
BoxShadow(
color: Color(0xFF3A5160).withOpacity(0.5),
offset: Offset(1.1, 1.1),
blurRadius: 10.0),
],
),
child: Padding(
padding: const EdgeInsets.only(left: 10, right: 10),
child: Center(
child: SingleChildScrollView(
child: Container(
height: MediaQuery.of(context).size.height * 0.5,
width: double.infinity,
child: Column(
mainAxisAlignment: MainAxisAlignment.start,
crossAxisAlignment: CrossAxisAlignment.start,
mainAxisSize: MainAxisSize.min,
children: <Widget>[
Padding(
padding: const EdgeInsets.only(
top: 25.0, left: 10, right: 10),
child: Center(
child: Text(
"Quote Category",
textAlign: TextAlign.center,
style: TextStyle(
fontWeight: FontWeight.w600,
fontSize: 22,
color: Colors.white,
),
),
),
),
Expanded(
child: Padding(
padding: const EdgeInsets.only(top: 15.0),
child: SingleChildScrollView(
child: Text(
"Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum "
"Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum "
"Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum "
"Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum "
"Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum "
"Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum "
"Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum "
"Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum "
"Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum "
"Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum "
"Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum "
"Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum ",
textAlign: TextAlign.center,
style: TextStyle(color: Colors.white),
),
),
),
),
SizedBox(
height: 20.0,
),
],
),
),
),
),
),
),
),*/
