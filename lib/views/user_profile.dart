import 'package:cookit/util/size_config1.dart';
import 'package:cookit/views/my_recipes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cookit/custom/globals.dart' as globals;

import 'edit_profile.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: WillPopScope(
          onWillPop: () {
            Navigator.pop(context);
          },
          child: Scaffold(
            backgroundColor:
                globals.darkModeOn ? Colors.grey[850] : Colors.white,
            body: Stack(
              children: [
                Container(
                    width: SizeConfig.width(480),
                    height: SizeConfig.height(1013.3333333333334) / 4.7,
                    color: Colors.red,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: SizeConfig.width(10),
                              bottom: SizeConfig.height(960)),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              size: 40,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: SizeConfig.width(360),
                              bottom: SizeConfig.height(960)),
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                  new MaterialPageRoute(builder: (context) {
                                return EditProfile();
                              }));
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 40,
                            ),
                          ),
                        ),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.width(360) / 2,
                      top: (SizeConfig.height(1013.3333333333334) / 4.7) -
                          SizeConfig.width(80)),
                  width: SizeConfig.width(160),
                  height: SizeConfig.width(160),
                  decoration: BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(
                      top: (SizeConfig.height(1013.3333333333334) / 4.7) +
                          SizeConfig.width(80) +
                          20),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        child: Text(
                          "frvgfvsdfsefsfcsfewafc",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.grey,
                            fontFamily: 'Livvic',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        child: Text(
                          "frvgfvsdfsefsfcsfewafc",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.grey,
                            fontFamily: 'Livvic',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Material(
                        elevation: 8,
                        child: Container(
                          width: MediaQuery.of(context).size.width -
                              SizeConfig.width(30),
                          height: SizeConfig.height(160),
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.height(80),
                      ),
                      TextButton(onPressed: (){
                        Navigator.of(context).push(new MaterialPageRoute(builder: (context){
                          return MyRecipes();
                        }));
                      }, child: Container(
                        width: SizeConfig.width(220),
                        height: SizeConfig.height(60),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(40)),
                        child: Container(
                          margin: EdgeInsets.only(
                              left: SizeConfig.width(35),
                              right: SizeConfig.width(35)),
                          width: SizeConfig.width(100),
                          height: SizeConfig.height(60),
                          decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(40)),
                          child: Center(
                            child: Text(
                              'My Recipes',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Livvic'),
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
                Positioned(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: SizeConfig.height(80),
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        "SIGN OUT",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Livvic',
                            fontSize: 25),
                      ),
                    ),
                  ),
                  left: 10,
                  right: 10,
                  bottom: 10,
                )
              ],
            ),
          ),
        ));
  }
}
