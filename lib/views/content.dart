import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookit/custom/globals.dart' as globals;
import 'package:cookit/util/size_config1.dart';
import 'package:cookit/views/searching.dart';
import 'package:flutter/cupertino.dart';
import 'package:cookit/database/firebase_db.dart' as fdb;
import 'package:flutter/material.dart';

class Content extends StatefulWidget {
  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  bool isLoading = true;
  int index = 1;
  Widget page;
  var widgets = [];
  PageController _pageController;
  Duration pageTurnDuration = Duration(milliseconds: 500);
  Curve pageTurnCurve = Curves.ease;

  @override
  void initState() {
    getRec();
    page = _firstPage();
    widgets = [_firstPage(),_secondPage(),_thirdPage()];
    _pageController = PageController();
    super.initState();
  }

  void _goForward() {
    _pageController.nextPage(duration: pageTurnDuration, curve: pageTurnCurve);
  }

  void _goBack() {
    _pageController.previousPage(
        duration: pageTurnDuration, curve: pageTurnCurve);
  }

  getRec() async {
    await fdb.FirebaseDB.getRecipeDashBoard();
    startTimer();
  }

  startTimer(){
    return Timer(new Duration(seconds: 2),(){
      setState(() {
        isLoading = false;
      });
    });
  }

  Widget _firstPage() {
    return Stack(
      children: [
        Positioned(
          child: Container(
            width: SizeConfig.width(200),
            child: Text(
              globals.selectedRecipe.name.toUpperCase(),
              softWrap: true,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 40,
                  fontFamily: 'Livvic'),
            ),
          ),
          bottom: 30,
          left: 30,
        ),
        Positioned(
          child: IconButton(
            onPressed: () {
              setState(() {
                index += 1;
              });
              _goForward();
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 50,
            ),
          ),
          top: 220,
          right: 30,
        )
      ],
    );
  }

  Widget _secondPage() {
    return Stack(
      children: [
        Positioned(
          child: IconButton(
            onPressed: () {
              setState(() {
                index -= 1;
              });
              _goBack();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 50,
            ),
          ),
          top: 220,
          left: 30,
        ),
        Positioned(
          child: Container(
            width: SizeConfig.width(340),
            height: SizeConfig.height(590),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 22),
            child: Column(
              children: [
                Text('INGREDIENTS',style: TextStyle(
                  color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 20),
                Container(
                  child: ListView(
                    children: List.generate(
                        globals.selectedRecipe.ingredients.length, (index) {
                      return Container(
                        width: SizeConfig.width(330),
                        height: SizeConfig.height(50),
                        child: Text(
                          (index + 1).toString() +
                              ". " +
                              globals.selectedRecipe.ingredients[index],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,fontFamily: 'Livvic'),textAlign: TextAlign.left ,
                        ),
                      );
                    }),
                  ),
                  height: SizeConfig.height(500),
                )
              ],
            ),
          ),
          top: 0,
          left: 50,
          right: 50,
        ),
        Positioned(
          child: IconButton(
            onPressed: () {
              setState(() {
                index += 1;
              });
              _goForward();
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 50,
            ),
          ),
          top: 220,
          right: 30,
        ),
      ],
    );
  }

  Widget _thirdPage() {
    return Stack(
      children: [
        Positioned(
          child: IconButton(
            onPressed: () {
              setState(() {
                index -= 1;
              });
              _goBack();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 50,
            ),
          ),
          top: 220,
          left: 30,
        ),
        Positioned(
          child: Container(
            width: SizeConfig.width(340),
            height: SizeConfig.height(590),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 22),
            child: Column(
              children: [
                Text('STEPS',style: TextStyle(
                    color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 20),
                Container(
                  child: ListView(
                    children: List.generate(
                        globals.selectedRecipe.recipe.length, (index) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        width: SizeConfig.width(330),
                        child: Text(
                          (index + 1).toString() +
                              ". " +
                              globals.selectedRecipe.recipe[index],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,fontFamily: 'Livvic'),textAlign: TextAlign.left ,
                        ),
                      );
                    }),
                  ),
                  height: SizeConfig.height(500),
                )
              ],
            ),
          ),
          top: 0,
          left: 50,
          right: 50,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
          onWillPop: () {
            Navigator.pop(context);
          },
          child: Scaffold(
            backgroundColor:
                isLoading ? Colors.white.withOpacity(0.5) : Colors.white,
            body: isLoading
                ? _loadingDialog()
                : Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.grey.withOpacity(0.5),
                                BlendMode.srcOver),
                            fit: BoxFit.cover,
                            image:
                                NetworkImage(globals.selectedRecipe.imageUrl))),
                    child: Column(
                      children: [
                        Container(
                          width: SizeConfig.width(440),
                          height: SizeConfig.height(100),
                          margin: EdgeInsets.only(
                              left: 20, top: 35.0, bottom: 10.0),
                            child: Material(
                              color: Color.fromRGBO(
                                  255, 255, 255, 0.5019607843137255),
                              elevation: 10.0,
                              borderRadius: BorderRadius.circular(25.0),
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
                                enabled: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon:
                                        Icon(Icons.search, color: Colors.white),
                                    contentPadding:
                                        EdgeInsets.only(left: 15.0, top: 15.0),
                                    hintText: 'Search for recipes and channels',
                                    hintStyle: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                              ),
                            ),
                        ),
                        Container(
                          width: SizeConfig.width(440),
                          height: SizeConfig.width(500),
                          child: GestureDetector(
                            onHorizontalDragEnd: (dragEndDetails) {
                              if (dragEndDetails.primaryVelocity < 0) {
                                if (index == 1) {
                                  setState(() {
                                    index += 1;
                                  });
                                  _goForward();
                                } else if (index == 2) {
                                  setState(() {
                                    index += 1;
                                  });
                                  _goForward();
                                }
                              } else {
                                if (index == 2) {
                                  setState(() {
                                    index -= 1;
                                  });
                                  _goBack();
                                } else if (index == 3) {
                                  setState(() {
                                    index -= 1;
                                  });
                                  _goBack();
                                }
                              }
                            },
                            child: PageView.builder(itemCount: 3,
                                controller: _pageController,
                                // NeverScrollableScrollPhysics disables PageView built-in gestures.
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index){
                              return widgets[index];
                                }),
                          ),
                        ),
                        // Container(
                        //   height: SizeConfig.height(300),
                        //   color: Colors.red,
                        //   width: SizeConfig.width(440),
                        //   padding: EdgeInsets.symmetric(vertical: SizeConfig.height(60)),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //
                        //     ],
                        //   ),
                        // )
                        Container(
                          width: SizeConfig.width(440),
                          padding: EdgeInsets.only(top: 15.0, left: 30.0),
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
                    ),
                  ),
          ),
        ),
        top: true);
  }

  Widget _foodCard(name, chef, url, chef_url) {
    return Container(
      height: SizeConfig.height(160),
      width: MediaQuery.of(context).size.width - SizeConfig.width(20),
      margin: EdgeInsets.only(
          top: SizeConfig.height(10),
          left: SizeConfig.width(10),
          right: SizeConfig.width(10)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: <Widget>[
            CachedNetworkImage(
              imageBuilder: (context, imageProvider) => Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
                height: SizeConfig.height(140),
                width: SizeConfig.width(140),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                    shape: BoxShape.circle),
              ),
              placeholder: (context, url) => Center(
                child: Container(
                  height: SizeConfig.height(40),
                  width: SizeConfig.width(40),
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Icon(
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
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    softWrap: true,
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  height: 2.0,
                  width: SizeConfig.width(200),
                  color: Colors.orange,
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageBuilder: (context, imageProvider) => Container(
                        height: SizeConfig.height(25),
                        width: SizeConfig.width(25),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                            shape: BoxShape.circle),
                      ),
                      placeholder: (context, url) => Center(
                        child: Container(
                          height: SizeConfig.height(25),
                          width: SizeConfig.width(25),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.error,
                        size: 18,
                      ),
                      imageUrl: chef_url,
                    ),
                    SizedBox(width: 10.0),
                    Text(chef,
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 20,
                            color: Colors.white))
                  ],
                )
              ],
            )
          ],
        ),
        color: Colors.white.withOpacity(0.7),
      ),
    );
  }

  Widget _loadingDialog() {
    return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        backgroundColor: Colors.white,
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
