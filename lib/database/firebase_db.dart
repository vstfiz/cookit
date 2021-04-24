
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cookit/custom/globals.dart' as globals;
import 'package:cookit/model/recipe.dart';
import 'package:cookit/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit/views/fill_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cookit/views/dashboard.dart';

class FirebaseDB {

  static Future<void> getRecipeDashBoard() async{
    Firestore firestore = Firestore.instance;
    var ref = firestore.collection('recipes');
    QuerySnapshot querySnapshot = await ref.getDocuments();
    int limit = querySnapshot.documents.length;
    print('limit is'+limit.toString());
    Random r = new Random();
    List<DocumentSnapshot> ds = querySnapshot.documents;
    List<Recipe> recipes = [];
    var indexes = [];
    while(indexes.length!=6){
      int index = r.nextInt(limit);
      if(!(indexes.contains(index))){
        print('random is' + index.toString());
        indexes.add(index);
      }
    }
    for(int i=0;i<6;i++){
      Recipe rec = new Recipe(ds[indexes[i]]['name'], ds[indexes[i]]['chef_name'], ds[indexes[i]]['reference'], ds[indexes[i]]['imageUrl'], ds[indexes[i]]['ingredients'], ds[indexes[i]]['chef_dp'], ds[indexes[i]]['recipe']);
      print(rec.toString()+'\n\n');
      recipes.add(rec);
    }
    globals.recipes = recipes;
  }

  static Future<void> getBestOfTheDay() async{
    Firestore firestore = Firestore.instance;
    var ref = firestore.collection('recipes');
    QuerySnapshot querySnapshot = await ref.getDocuments();
    int limit = querySnapshot.documents.length;
    print('limit is'+limit.toString());
    Random r = new Random();
    List<DocumentSnapshot> ds = querySnapshot.documents;
    List<Recipe> recipes = [];
    int index = r.nextInt(limit);
    globals.bestOfTheDay = new Recipe(ds[index]['name'], ds[index]['chef_name'], ds[index]['reference'], ds[index]['imageUrl'], ds[index]['ingredients'], ds[index]['chef_dp'], ds[index]['recipe']);
  }


  static Future<User> getUserDetails(String uid, BuildContext context) async {
    Firestore firestore = Firestore.instance;
    var ref = firestore.collection('users');
    print(uid);
    QuerySnapshot querySnapshot =
    await ref.where('uid', isEqualTo: uid).getDocuments();
    List<DocumentSnapshot> ds = querySnapshot.documents;
    if (ds.isEmpty) {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => FillDetails()));
    } else {
      DocumentSnapshot document = ds.single;
      globals.mainUser = new User(
          document['name'],
          document['profession'],
          document['phone'],
          document['email'],
          document['gender'],
          document['displayUrl'],
          document['uid']);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return Dashboard();
      }));
    }
  }

  static Future<bool> createUser(name, mail, gender, phone, iAmA,
      imageUrl) async {
    globals.mainUser =
    new User(
        name,
        "",
        phone,
        mail,
        gender,
        imageUrl,
        globals.user.uid);
    Firestore firestore = Firestore.instance;
    var ref = firestore.collection('users');
    Map<String, String> userData = new Map<String, String>();
    userData.putIfAbsent('name', () => name);
    userData.putIfAbsent('email', () => mail);
    userData.putIfAbsent('gender', () => gender);
    userData.putIfAbsent('phone', () => phone);
    userData.putIfAbsent('profession', () => iAmA);
    userData.putIfAbsent('uid', () => globals.user.uid);
    userData.putIfAbsent('displayUrl', () => imageUrl);
    userData
        .forEach((String k, String v) => print("k is: " + k + "v is  : " + v));
    ref.add(userData);
  }

  static Future<bool> updateDetails(name, mail, gender, phone, age,dp) async {
    Firestore firestore = Firestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('uid', isEqualTo: globals.user.uid)
        .getDocuments();
    String ds = querySnapshot.documents.single.documentID;
    Map<String, String> userData = new Map<String, String>();
    userData.putIfAbsent('name', () => name);
    userData.putIfAbsent('email', () => mail);
    userData.putIfAbsent('gender', () => gender);
    userData.putIfAbsent('phone', () => phone);
    userData.putIfAbsent('age', () => age);
    userData.putIfAbsent('displayUrl', () => dp);
    userData
        .forEach((String k, String v) => print("k is: " + k + "v is  : " + v));
    var ref = firestore.collection('users').document(ds).updateData(userData);
  }

  static getRecipeCount() async{
    print(globals.mainUser.uid);
   QuerySnapshot qureySnapshots = await Firestore.instance.collection('recipes').where('reference',isEqualTo: globals.mainUser.uid).getDocuments();
   int k = qureySnapshots.documents.length;
    print(k);
    globals.count = k;
  }
}