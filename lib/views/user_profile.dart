import 'package:cached_network_image/cached_network_image.dart';
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
  int count = 0;
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
                globals.darkModeOn ? Colors.grey[850] : Color(0xFFFFF5EB),
            body: Stack(
              children: [
                Container(
                    width: SizeConfig.width(480),
                    height: SizeConfig.height(1013.3333333333334) / 4.7,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/cover.jpg',),fit: BoxFit.cover
                      )
                    ),
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
                CachedNetworkImage(
                  imageBuilder: (context, imageProvider) => Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.width(360) / 2,
                        top: (SizeConfig.height(1013.3333333333334) / 4.7) -
                            SizeConfig.width(80)),
                    width: SizeConfig.width(160),
                    height: SizeConfig.width(160),
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
                  imageUrl: globals.user.dp,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(
                      top: (SizeConfig.height(1013.3333333333334) / 4.7) +
                          SizeConfig.width(80) +
                          20),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10),
                        child: Text(
                          globals.user.name,
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
                            top: 10, bottom: 10),
                        child: Text(
                          globals.user.email,
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
                        color: Colors.transparent,
                        elevation: 8,
                        child: Container(
                          width: MediaQuery.of(context).size.width -
                              SizeConfig.width(40),
                          height: SizeConfig.height(100),
                          padding: EdgeInsets.symmetric(vertical: SizeConfig.height(25)),
                          child: Text(
                            '${count} Recipes',style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Livvic',fontSize: 30
                          ),softWrap: true,textAlign: TextAlign.center,
                          ),
                          decoration: BoxDecoration(
                              color: globals.darkModeOn?Colors.black:Colors.white,
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
                        color: Colors.blue,
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
