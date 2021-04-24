library globals;

import 'dart:core';

import 'package:cookit/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:cookit/model/recipe.dart';

User user = new User("", "", "", "", "", "", "");
User mainUser = new User("", "", "", "", "", "", "");

double width(double width) {}

double height(double height) {}
bool darkModeOn = true;
bool isPortrait;
bool otpSent = false;
bool isPlaying = false;
bool isOtpLogin = false;
List<String> i1 = [];
List<String> i2 = [];
List<Recipe> recipes = [];
bool isEmailLogin = false;
bool isFireLogin = false;
Recipe bestOfTheDay;
Recipe selectedRecipe = new Recipe("name", "chef_name", "reference", "https://www.spiceupthecurry.com/wp-content/uploads/2020/07/mint-chutney-2-1024x1536.jpg", ["fesfs","fesafcs","bvdtgbrfve","grgvrfvsdrzED","dawev fgberfgrvaeZfgvrfe","gvfdrvres","fseefcse","fsefse","dasdWdwa","dawefccfsa","fcaegvrf"], "chef_dp", ["6To piggy back off of @Vimal Rai's answer. I found that onHorizontalDragUpdate calls the function with every update. That could lead to unwanted behavior in your app. If you want the function to be called just once upon swiping, go with OnHorizontalDragEnd:","fesfs","fesafcs","bvdtgbrfve","grgvrfvsdrzED","dawev fgberfgrvaeZfgvrfe","gvfdrvres","fseefcse","fsefse","dasdWdwa","dawefccfsa","fcaegvrf"]);
TextEditingController usernameController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();
TextEditingController cnfPasswordController = new TextEditingController();
TextEditingController mobileController = new TextEditingController();
TextEditingController otpController = new TextEditingController();
BuildContext cont;
