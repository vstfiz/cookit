import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookit/util/size_config1.dart';
import 'package:cookit/views/searching.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cookit/custom/globals.dart' as globals;
import 'package:cookit/views/user_profile.dart';
import 'package:cookit/views/settings.dart';
import 'package:cookit/database/firebase_db.dart' as fdb;
import 'package:flutter/services.dart';

import 'content.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isLoading = true;
  String currDate = '';
  var monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  @override
  void initState() {
    var date = new DateTime.now();
    print(date.day);
    print(monthNames[date.month - 1]);
    currDate = monthNames[date.month - 1] + " " + date.day.toString();
   getRec();
    super.initState();
  }

  getRec() async{
    await fdb.FirebaseDB.getRecipeDashBoard();
    await fdb.FirebaseDB.getBestOfTheDay();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> exitDialog() {
    return showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text(
                "Exit",
                style: TextStyle(fontSize: 30, fontFamily: "Livvic"),
              ),
              content: Text(
                "Do you want to exit ?",
                style: TextStyle(fontSize: 20, fontFamily: "Livvic"),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Livvic",
                        color: Colors.grey[800]),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Livvic",
                        color: Colors.grey[800]),
                  ),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: true,
        top: true,
        right: true,
        left: true,
        child: WillPopScope(
          onWillPop: () {
            exitDialog();
          },
          child: Scaffold(
            backgroundColor: isLoading?Color(0xFFFFF5EB).withOpacity(0.5):Color(0xFFFFF5EB),
            body: isLoading
                ? _loadingDialog()
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 340.0,
                              color: Color(0xFFffe6cc),
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Container(
                                      width: SizeConfig.width(400),
                                      margin: EdgeInsets.only(
                                          left: 20, top: 35.0, bottom: 10.0),
                                        child: Material(
                                          elevation: 10.0,
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          child: TextFormField(
                                            onChanged: (searchValue){
                                              print(searchValue);
                                            },
                                            onTap: (){
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder: (context) {
                                                    return Searching();
                                                  }));
                                            },
                                            enabled: true ,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                prefixIcon: Icon(Icons.search,
                                                    color: Colors.black),
                                                contentPadding: EdgeInsets.only(
                                                    left: 15.0, top: 15.0),
                                                hintText:
                                                    'Search for recipes and channels',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey)),
                                          ),
                                        ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    // Container(
                                    //
                                    //       color: Colors.red,
                                    //   child:,
                                    //     child:

                                    CachedNetworkImage(
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        child: FlatButton(onPressed: () {
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (context) {
                                            return UserProfile();
                                          }));
                                        }),
                                        margin: EdgeInsets.only(
                                            top: 35.0, bottom: 10.0),
                                        height: SizeConfig.height(40),
                                        width: SizeConfig.width(40),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                            shape: BoxShape.circle),
                                      ),
                                      placeholder: (context, url) => Center(
                                        child: Container(
                                          height: SizeConfig.height(40),
                                          width: SizeConfig.width(40),
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(
                                        Icons.error,
                                        size: 18,
                                      ),
                                      imageUrl: globals.mainUser.dp,
                                    ),
                                    // ),
                                    // ),
                                  ],
                                ),
                                SizedBox(height: 40.0),
                                Padding(
                                  padding: EdgeInsets.only(left: 15.0),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: Colors.orange,
                                                style: BorderStyle.solid,
                                                width: 3.0))),
                                    child: Row(
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('POPULAR RECIPES',
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontFamily: 'Timesroman',
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text('THIS WEEK',
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontFamily: 'Timesroman',
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: SizeConfig.width(175.5)),
                                          width:
                                              10 * SizeConfig.heightMultiplier,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1 *
                                                  SizeConfig.heightMultiplier),
                                          decoration: BoxDecoration(
                                            color: globals.darkModeOn
                                                ? Colors.pink
                                                : Colors.black,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(3.0 *
                                                  SizeConfig.heightMultiplier),
                                              bottomLeft: Radius.circular(3.0 *
                                                  SizeConfig.heightMultiplier),
                                            ),
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.settings,
                                              color: Colors.white,
                                              size: 6 *
                                                  SizeConfig
                                                      .imageSizeMultiplier,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  new MaterialPageRoute(
                                                      builder: (context) {
                                                return Content();
                                              }));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20.0),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(top: 15.0, left: 30.0),
                                  margin: EdgeInsets.only(top: 40),
                                  height: 180.0,
                                  child: ListView(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: <Widget>[
                                      _foodCard(
                                          globals.recipes[0].name,
                                          globals.recipes[0].chef_name,
                                          globals.recipes[0].imageUrl,
                                          globals.recipes[0].chef_dp),
                                      SizedBox(width: 30.0),
                                      _foodCard(
                                          globals.recipes[1].name,
                                          globals.recipes[1].chef_name,
                                          globals.recipes[1].imageUrl,
                                          globals.recipes[1].chef_dp),
                                      SizedBox(width: 30.0),
                                      _foodCard(
                                          globals.recipes[2].name,
                                          globals.recipes[2].chef_name,
                                          globals.recipes[2].imageUrl,
                                          globals.recipes[2].chef_dp),
                                      SizedBox(width: 30.0),
                                      _foodCard(
                                          globals.recipes[3].name,
                                          globals.recipes[3].chef_name,
                                          globals.recipes[3].imageUrl,
                                          globals.recipes[3].chef_dp),
                                      SizedBox(width: 30.0),
                                      _foodCard(
                                          globals.recipes[4].name,
                                          globals.recipes[4].chef_name,
                                          globals.recipes[4].imageUrl,
                                          globals.recipes[4].chef_dp),
                                      SizedBox(width: 30.0),
                                      _foodCard(
                                          globals.recipes[5].name,
                                          globals.recipes[5].chef_name,
                                          globals.recipes[5].imageUrl,
                                          globals.recipes[5].chef_dp),
                                      SizedBox(width: 30.0),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            currDate,
                            style: TextStyle(
                                fontFamily: 'Quicksand',
                                color: Colors.grey,
                                fontSize: 14.0),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            'TODAY',
                            style: TextStyle(
                                fontFamily: 'Timesroman',
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 12.0, right: 12.0),
                              child: CachedNetworkImage(
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      height: SizeConfig.height(420),
                                      width: MediaQuery.of(context).size.width - SizeConfig.width(20),
                                      margin: EdgeInsets.only(left: SizeConfig.width(10)),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                          shape: BoxShape.circle),
                                    ),
                                placeholder: (context, url) => Center(
                                  child: Container(
                                    height: SizeConfig.height(25),
                                    width: SizeConfig.width(25),
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(
                                      Icons.error,
                                      size: 18,
                                    ),
                                imageUrl: globals.bestOfTheDay.imageUrl,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(128, 128, 128, 0.6),
                                borderRadius: BorderRadius.circular(10)
                              ),

                                margin:
                                    EdgeInsets.only(top: 300.0, left: 60.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'BEST OF',
                                      style: TextStyle(
                                          fontFamily: 'Timesroman',
                                          fontSize: 25.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'THE DAY',
                                      style: TextStyle(
                                          fontFamily: 'Timesroman',
                                          fontSize: 25.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10.0),
                                    Container(
                                      height: 3.0,
                                      width: 50.0,
                                      color: Colors.orange,
                                    )
                                  ],
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
          ),
        ));
  }

  Widget _foodCard(name, chef, url, chef_url) {
    return Container(
      height: 180.0,
      width: 350.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          CachedNetworkImage(
            imageBuilder: (context, imageProvider) =>
                Container(
                  margin: EdgeInsets.only(left: 10,top: 10,bottom: 10),
                  height: SizeConfig.height(130),
                  width: SizeConfig.width(130),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover),
                      shape: BoxShape.circle),
                ),
            placeholder: (context, url) => Center(
              child: Container(
                height: SizeConfig.height(40),
                width: SizeConfig.width(40),
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) =>
                Icon(
                  Icons.error,
                  size: 18,
                ),
            imageUrl: url,
          ),
          SizedBox(width: 40.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: SizeConfig.width(160),
                child: Text(
                  name,
                  style: TextStyle(fontFamily: 'Quicksand', fontSize: 18,),softWrap: true,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                height: 2.0,
                width: 160.0,
                color: Colors.orange,
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CachedNetworkImage(
                    imageBuilder: (context, imageProvider) =>
                        Container(
                          height: SizeConfig.height(25),
                          width: SizeConfig.width(25),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover),
                              shape: BoxShape.circle),
                        ),
                    placeholder: (context, url) => Center(
                      child: Container(
                        height: SizeConfig.height(25),
                        width: SizeConfig.width(25),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        Icon(
                          Icons.error,
                          size: 18,
                        ),
                    imageUrl: chef_url,
                  ),
                  SizedBox(width: 20.0),
                  Text(chef,
                      style: TextStyle(fontFamily: 'Quicksand'))
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _loadingDialog() {
    return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        backgroundColor: Colors.white.withOpacity(0.5),
        content: Container(
            height: SizeConfig.height(60),
            child: Center(
              child: Row(
                children: <Widget>[
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  SizedBox(
                    width: SizeConfig.width(20),
                  ),
                  Text(
                    "Loading Data...",
                    style: TextStyle(
                        fontFamily: "Livvic", fontSize: 23, letterSpacing: 1),
                  )
                ],
              ),
            )));
  }
}
