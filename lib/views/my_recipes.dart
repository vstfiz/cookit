import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit/custom/globals.dart';
import 'package:cookit/model/recipe.dart';
import 'package:cookit/util/size_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cookit/custom/globals.dart' as globals;
import 'package:cookit/database/firebase_db.dart' as fdb;

class MyRecipes extends StatefulWidget {
  @override
  _MyRecipesState createState() => _MyRecipesState();
}

class _MyRecipesState extends State<MyRecipes> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFFFF5EB),
          body: Stack(
            children: [
              Positioned(
                  bottom: 10,
                  right: SizeConfig.width(170),
                  child: Container(
                    height: SizeConfig.height(70),
                    width: SizeConfig.width(70),
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) => FunkyOverlay(),
                        );
                        //add my recipe
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  )),
              Positioned(
                child: Container(
                  height: SizeConfig.height(780),
                  child: SingleChildScrollView(
                    child: StreamBuilder(
                      stream: Firestore.instance
                          .collection('recipes')
                          .where('reference', isEqualTo: user.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text(
                              'You don\'t have any recipe of your own.',
                              style: TextStyle(
                                  fontFamily: 'Livvic',
                                  color: Colors.grey,
                                  fontSize: 25),
                            ),
                          );
                        } else {
                          print(snapshot.data.documents.length);
                          return Column(
                            children: List.generate(
                                snapshot.data.documents.length, (index) {
                              return _foodCard(
                                  snapshot.data.documents[index]['name'],
                                  snapshot.data.documents[index]['imageUrl'],
                                  snapshot.data.documents[index]['chef_name'],
                                  snapshot.data.documents[index]['chef_dp']);
                            }),
                          );
                        }
                      },
                    ),
                  ),
                ),
                top: 0,
              ),
            ],
          ),
        ),
        top: true,
        bottom: true);
  }

  Widget _foodCard(name, url, chef, chef_url) {
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
                Text(
                  name,
                  style: TextStyle(fontFamily: 'Quicksand', fontSize: 20),
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
                        style: TextStyle(fontFamily: 'Quicksand', fontSize: 20))
                  ],
                )
              ],
            )
          ],
        ),
        color: Colors.white,
      ),
    );
  }
}

class FunkyOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _chefNameController = new TextEditingController();
  TextEditingController _ingredientController = new TextEditingController();
  TextEditingController _recipeController = new TextEditingController();
  var ingredients = [];
  File _image;
  File _chefImage;
  var recipe = [];
  String uploadedImageUrl;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  Future getCameraImage1() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(pickedFile.path);
    });
    print("Path Value : " + _image.path);
  }

  Future getGalleryImage1() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future getCameraImage2() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _chefImage = File(pickedFile.path);
    });
    print("Path Value : " + _image.path);
  }

  Future getGalleryImage2() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _chefImage = File(pickedFile.path);
    });
  }

  Future<String> uploadImage(File val) async {
    print("image upload running");
    final StorageReference ref = FirebaseStorage.instance.ref().child(
        'users/${globals.mainUser.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final StorageUploadTask uploadTask = ref.put(val);
    await uploadTask.onComplete;
    var uri = await ref.getDownloadURL();
    uploadedImageUrl = uri.toString();
    print(uploadedImageUrl);
    return uploadedImageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            height: SizeConfig.height(800),
            width: SizeConfig.width(403),
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Stack(
              children: [
                Positioned(
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  right: 5,
                ),
                Positioned(
                  child: GestureDetector(
                    onTap: () {
                      Focus.of(context).unfocus();
                    },
                    child: Container(
                      height: SizeConfig.height(705),
                      width: SizeConfig.width(393),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: SizeConfig.height(45),
                              width: SizeConfig.width(383),
                              child: TextField(
                                controller: _nameController,
                                style: TextStyle(fontFamily: 'Livvic'),
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  labelStyle: TextStyle(fontFamily: 'Livvic'),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 2.0)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: SizeConfig.height(45),
                              width: SizeConfig.width(383),
                              child: TextField(
                                controller: _chefNameController,
                                style: TextStyle(fontFamily: 'Livvic'),
                                decoration: InputDecoration(
                                  labelText: 'Chef\'s Name',
                                  hintText: globals.mainUser.name,
                                  hintStyle: TextStyle(fontFamily: 'Livvic'),
                                  labelStyle: TextStyle(fontFamily: 'Livvic'),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 2.0)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: SizeConfig.height(45),
                              width: SizeConfig.width(383),
                              child: TextField(
                                controller: _ingredientController,
                                style: TextStyle(fontFamily: 'Livvic'),
                                decoration: InputDecoration(
                                  labelText: 'Ingredient',
                                  labelStyle: TextStyle(fontFamily: 'Livvic'),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 2.0)),
                                ),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  var newList = ingredients;
                                  newList.add(_ingredientController.text);
                                  setState(() {
                                    ingredients = newList;
                                  });
                                  _ingredientController.clear();
                                },
                                child: Text(
                                  'Add Ingredient',
                                  style: TextStyle(fontFamily: 'Livvic'),
                                )),
                            Container(
                              height: SizeConfig.height(100),
                              width: SizeConfig.width(383),
                              child: ListView(
                                children:
                                    List.generate(ingredients.length, (index) {
                                  return Container(
                                    width: SizeConfig.width(383),
                                    height: SizeConfig.height(20),
                                    child: Text(
                                      '${index}. ${ingredients[index]}',
                                      style: TextStyle(
                                          fontFamily: 'Livvic', fontSize: 18),
                                      softWrap: true,
                                    ),
                                  );
                                }),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: SizeConfig.height(45),
                              width: SizeConfig.width(383),
                              child: TextField(
                                controller: _recipeController,
                                style: TextStyle(fontFamily: 'Livvic'),
                                decoration: InputDecoration(
                                  labelText: 'Recipe Steps',
                                  labelStyle: TextStyle(fontFamily: 'Livvic'),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 2.0)),
                                ),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  var newList = recipe;
                                  newList.add(_recipeController.text);
                                  setState(() {
                                    recipe = newList;
                                  });
                                  _recipeController.clear();
                                },
                                child: Text(
                                  'Add Recipe Step',
                                  style: TextStyle(fontFamily: 'Livvic'),
                                )),
                            Container(
                              height: SizeConfig.height(100),
                              width: SizeConfig.width(383),
                              child: ListView(
                                children: List.generate(recipe.length, (index) {
                                  return Container(
                                    width: SizeConfig.width(383),
                                    height: SizeConfig.height(27),
                                    child: Text(
                                      '${index}. ${recipe[index]}\n',
                                      style: TextStyle(
                                          fontFamily: 'Livvic', fontSize: 18),
                                      softWrap: true,
                                    ),
                                  );
                                }),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: SizeConfig.height(45),
                              width: SizeConfig.width(383),
                              child: Row(
                                children: [
                                  Text('Food\'s Image:'),
                                  SizedBox(
                                    width: SizeConfig.width(60),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey.withOpacity(0.5)),
                                    width: SizeConfig.width(60),
                                    child: IconButton(
                                        onPressed: getCameraImage1,
                                        icon: Icon(Icons.camera_alt)),
                                  ),
                                  SizedBox(
                                    width: SizeConfig.width(60),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey.withOpacity(0.5)),
                                    width: SizeConfig.width(60),
                                    child: IconButton(
                                        onPressed: getGalleryImage1,
                                        icon: Icon(Icons.camera)),
                                  ),
                                ],
                              ),
                            ),
                            _image != null
                                ? Text(
                                    'Image Selected',
                                    style: TextStyle(fontFamily: 'Livvic'),
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: SizeConfig.height(20),
                            ),
                            Container(
                              height: SizeConfig.height(45),
                              width: SizeConfig.width(383),
                              child: Row(
                                children: [
                                  Text('Chef\'s Image:'),
                                  SizedBox(
                                    width: SizeConfig.width(60),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey.withOpacity(0.5)),
                                    width: SizeConfig.width(60),
                                    child: IconButton(
                                        onPressed: getCameraImage2,
                                        icon: Icon(Icons.camera_alt)),
                                  ),
                                  SizedBox(
                                    width: SizeConfig.width(60),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey.withOpacity(0.5)),
                                    width: SizeConfig.width(60),
                                    child: IconButton(
                                        onPressed: getGalleryImage2,
                                        icon: Icon(Icons.camera)),
                                  ),
                                ],
                              ),
                            ),
                            _chefImage != null
                                ? Text(
                                    'Image Selected',
                                    style: TextStyle(fontFamily: 'Livvic'),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ),
                  bottom: SizeConfig.height(60),
                  top: SizeConfig.height(35),
                  left: SizeConfig.height(5),
                ),
                Positioned(
                  left: 5,
                  child: Container(
                    width: SizeConfig.width(393),
                    height: SizeConfig.height(50),
                    child: TextButton(
                      onPressed: () {
                        uploadRecipe(_nameController.text,
                            _chefNameController.text, ingredients, recipe);
                      },
                      child: Center(
                        child: Text(
                          'UPLOAD',
                          style: TextStyle(
                              fontFamily: 'Livvic',
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  bottom: 5,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadingDialog() {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
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
                        "Uploading Data...",
                        style: TextStyle(
                            fontFamily: "Livvic",
                            fontSize: 23,
                            letterSpacing: 1),
                      )
                    ],
                  ),
                ))));
  }

  uploadRecipe(name, chef, ingredients, recipe) async {

    if (name != null && name != '') {
      if (chef != null && chef != '') {
        if (ingredients != null && ingredients.length != 0) {
          if (recipe != null && recipe.length != 0) {
            if (_image != null) {
              if (_chefImage != null) {
                _loadingDialog();
                String imageUrl = await uploadImage(_image);
                String chef_dp = await uploadImage(_chefImage);
                Recipe rec = new Recipe(name, chef, globals.mainUser.uid,
                    imageUrl, ingredients, chef_dp, recipe);
                await fdb.FirebaseDB.addRecipe(rec);
                print('uploaded');
                Navigator.pop(context);
                Navigator.pop(context);
                Fluttertoast.showToast(
                    msg: 'Recipe Uploaded Successfully',
                    toastLength: Toast.LENGTH_LONG);
              }
              else {
                _loadingDialog();
                String imageUrl = await uploadImage(_image);
                String chef_dp = globals.mainUser.dp;
                Recipe rec = new Recipe(name, chef, globals.mainUser.uid,
                    imageUrl, ingredients, chef_dp, recipe);
                await fdb.FirebaseDB.addRecipe(rec);
                print('uploaded');
                Navigator.pop(context);
                Navigator.pop(context);
                Fluttertoast.showToast(
                    msg: 'Recipe Uploaded Successfully',
                    toastLength: Toast.LENGTH_LONG);
              }
            }
            else{
              Fluttertoast.showToast(msg: 'Error Food Image not Selected',toastLength: Toast.LENGTH_LONG);
            }
          }
          else{
            Fluttertoast.showToast(msg: 'No Steps in the recipe has been added',toastLength: Toast.LENGTH_LONG);
          }
        }
        else{
          Fluttertoast.showToast(msg: 'No ingredients have been added',toastLength: Toast.LENGTH_LONG);
        }
      }
      else{
        Fluttertoast.showToast(msg: 'Invalid Chef\'s name, Please insert valid chef name',toastLength: Toast.LENGTH_LONG);
      }
    } else {
      Fluttertoast.showToast(msg: 'Invalid Recipe Name',toastLength: Toast.LENGTH_LONG);
    }
  }
}
