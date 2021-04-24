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

  Widget _foodCard(name, url, chef,chef_url) {
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
                      imageBuilder: (context, imageProvider) =>
                          Container(
                            height: SizeConfig.height(25),
                            width: SizeConfig.width(25),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover),
                                shape: BoxShape.circle),
                          ),
                      placeholder: (context, url) => Center(
                        child: Container(
                          height: SizeConfig.height(25),
                          width: SizeConfig.width(25),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(
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
