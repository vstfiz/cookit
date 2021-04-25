import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit/custom/globals.dart';
import 'package:cookit/util/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              Container(
                height: SizeConfig.height(826),
                child: SingleChildScrollView(
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('recipes')
                        .where('reference', isEqualTo: user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
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
              Positioned(
                  bottom: 0,
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
                  ))
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
  var recipe = [];

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
                                controller: _ingredientController,
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
                                children:
                                    List.generate(recipe.length, (index) {
                                  return Container(
                                    width: SizeConfig.width(383),
                                    height: SizeConfig.height(27),
                                    child:
                                        Text(
                                          '${index}. ${recipe[index]}\n',
                                          style: TextStyle(
                                              fontFamily: 'Livvic',
                                              fontSize: 18),
                                          softWrap: true,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  bottom: SizeConfig.height(60),
                  top: SizeConfig.height(35),
                  left: 5,
                ),
                Positioned(
                  left: 5,
                  child: Container(
                    width: SizeConfig.width(393),
                    height: SizeConfig.height(50),
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
}
