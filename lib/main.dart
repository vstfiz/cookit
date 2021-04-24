import 'dart:async';

import 'package:cookit/authentication/fire_auth.dart';
import 'package:cookit/database/firebase_db.dart' as fdb;
import 'package:cookit/custom/globals.dart' as globals;
import 'package:cookit/util/responsiveui.dart';
import 'package:cookit/util/size_config.dart';
import 'package:cookit/util/size_config1.dart' as s1;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cookit/views/content.dart';
import 'package:cookit/views/dashboard.dart';
import 'package:cookit/views/my_recipes.dart';
import 'package:cookit/views/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cookit/views/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(Phoenix(child: MyApp()));
  });
}

bool firstRun = true;
bool userValue;
FirebaseUser user;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    globals.cont = context;
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            s1.SizeConfig().init(constraints, orientation);
            return MaterialApp(
              title: 'Varithms',
              theme: globals.darkModeOn ? ThemeData(
                primarySwatch: Colors.orange,
              ) : ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: StreamBuilder(
                stream: auth.onAuthStateChanged,
                builder: (context, snapshot) {
                  print(SizeConfig.screenHeight);
                  print(SizeConfig.screenWidth);
                  if (snapshot.hasData) {
                    user = snapshot.data;
                    globals.user.email = user.email;
                    globals.user.dp = user.photoUrl;
                    globals.user.uid = user.uid;
                    globals.user.name = user.displayName;
                  }
                  return SplashScreen();
                },
              ),
            );
          },
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int countSplash = 1;
  String splash = 'assets/splash/1.jpg';
  String splashDark = 'assets/splash/1dark.jpg';
  @override
  void initState() {
    super.initState();
    print(auth.currentUser().toString());
    getDarkMode();
    if(globals.darkModeOn){
      updateSplashDark();
      print("d");
    }
    else{
      updateSplash();
      print("l");
    }
    startTime();
  }

  getDarkMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    globals.darkModeOn = sharedPreferences.getBool("darkMode");
    if (globals.darkModeOn == null) {
      globals.darkModeOn = true;
    }
  }

  updateSplash(){
    return new Timer(new Duration(milliseconds: 800), (){
      setState(() {
        countSplash += 1;
        splash =  'assets/splash/' + countSplash.toString() + '.jpg';
      });
      if(countSplash<5){updateSplash();}
    });
  }

  updateSplashDark(){
    return new Timer(new Duration(milliseconds: 800), (){
      setState(() {
        countSplash += 1;
        splashDark =  'assets/splash/' + countSplash.toString() + 'dark.jpg';
      });
      if(countSplash<5){updateSplashDark();}
    });
  }

  startTime() async {
    return new Timer(new Duration(milliseconds: 4000), navigator); //3950
  }

  navigator() {
      if (globals.user.email != null && globals.user.email != "") {
        fdb.FirebaseDB.getUserDetails(globals.user.uid, context);
        print(globals.user.email);
      }
      else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return Login();
        }));
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.darkModeOn ? Colors.black : Colors.white,
      body: globals.darkModeOn
            ? portraitStackDark(context)
            : portraitStackLight(context),
    );
  }

  Widget portraitStackLight(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: SizedBox(
            height: SizeConfig.height(250),
            width: SizeConfig.width(180),
            child: Image.asset(splash),
          ),
        ),
        Positioned(
          top: SizeConfig.height(700),
          left: SizeConfig.width(100),
          child: SizedBox(
            width: SizeConfig.width(340),
            child: Text("CookiT",
                style: TextStyle(
                    fontSize: 60.0,
                    fontFamily: "Aquire",
                    color: Colors.black,
                    letterSpacing: 10
                ),
                textAlign: TextAlign.start,
            ),
          ),
        ),
      ],
    );
  }

  Widget portraitStackDark(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: SizedBox(
            height: SizeConfig.height(250),
            width: SizeConfig.width(180),
            child: Image.asset(splashDark),
          ),
        ),
        Positioned(
          top: SizeConfig.height(700),
          left: SizeConfig.width(100),
          child: SizedBox(
            width: SizeConfig.width(340),
            child: Text(
                  "CookiT",
                style: TextStyle(
                    fontSize: 60.0,
                    fontFamily: "Aquire",
                    color: Colors.white,
                    letterSpacing: 10
                ),
                textAlign: TextAlign.start,),
          ),
        ),
      ],
    );
  }
}