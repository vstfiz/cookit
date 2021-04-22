import 'dart:ui';

import 'package:cookit/util/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String currDate = '';
  var monthNames = ["January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  @override
  void initState() {
    var date = new DateTime.now();
    print(date.day);
    print(monthNames[date.month-1]);
    currDate = monthNames[date.month-1] + " " + date.day.toString();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: true,
        top: true,
        right: true,
        left: true,
        child: WillPopScope(
          onWillPop: () {},
          child:Scaffold(
            backgroundColor: Color(0xFFFFF5EB),
            body:SingleChildScrollView(
              child:  Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 340.0,
                        color: Color(0xFFffe6cc),
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(15.0, 35.0, 15.0, 10.0),
                            child: FlatButton(
                              child:  Material(
                                elevation: 10.0,
                                borderRadius: BorderRadius.circular(25.0),
                                child: TextFormField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.search, color: Colors.black),
                                      contentPadding:
                                      EdgeInsets.only(left: 15.0, top: 15.0),
                                      hintText: 'Search for recipes and channels',
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                              ),
                              onPressed: (){},
                            ),
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('POPULAR RECIPES',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontFamily: 'Timesroman',
                                              fontWeight: FontWeight.bold)),
                                      Text('THIS WEEK',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontFamily: 'Timesroman',
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 15.0, left: 30.0),margin: EdgeInsets.only(top: 40),
                            height: 180.0,
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                _foodCard(),
                                SizedBox(width: 30.0),
                                _foodCard(),
                                SizedBox(width: 30.0),
                                _foodCard(),
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
                          fontSize: 14.0
                      ),
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
                          fontSize: 30.0
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 12.0, right: 12.0),
                        child: Container(
                          height: 420.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(image: AssetImage('assets/breakfast.jpg'), fit: BoxFit.cover)
                          ),
                          // child: BackdropFilter(
                          //   filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                          //   child: Container(
                          //     decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
                          //   ),
                          // ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 300.0, left: 60.0),
                          child: Column(
                            children: <Widget>[
                              Text('BEST OF',
                                style: TextStyle(
                                    fontFamily: 'Timesroman',
                                    fontSize: 25.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text('THE DAY',
                                style: TextStyle(
                                    fontFamily: 'Timesroman',
                                    fontSize: 25.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                height: 3.0,
                                width: 50.0,
                                color: Colors.orange,
                              )
                            ],
                          )
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget _foodCard() {
    return Container(
      height: 180.0,
      width: 350.0,
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image:
                DecorationImage(image: AssetImage('assets/balanced.jpg'))),
            height: 180.0,
            width: 160.0,
          ),
          SizedBox(width: 40.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Grilled Chicken\nwith Fruit Salad',
                style: TextStyle(fontFamily: 'Quicksand',fontSize: 15),
              ),
              SizedBox(height: 10.0),
              Container(
                height: 2.0,
                width: 75.0,
                color: Colors.orange,
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 25.0,
                    width: 25.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.5),
                        image: DecorationImage(
                            image: AssetImage('assets/chris.jpg'))),
                  ),
                  SizedBox(width: 10.0),
                  Text('James Oliver',
                      style: TextStyle(fontFamily: 'Quicksand'))
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
