library globals;

import 'dart:core';

import 'package:cookit/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:cookit/model/recipe.dart';

User user = new User("", "", "", "", "", "", "");
User mainUser = new User("", "", "", "", "", "", "");

double width(double width) {}

double height(double height) {}
bool darkModeOn = false;
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
Recipe selectedRecipe;
TextEditingController usernameController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();
TextEditingController cnfPasswordController = new TextEditingController();
TextEditingController mobileController = new TextEditingController();
TextEditingController otpController = new TextEditingController();
BuildContext cont;
