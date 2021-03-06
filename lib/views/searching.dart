import 'package:cookit/services/searching_service.dart';
import 'package:cookit/util/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cookit/custom/globals.dart' as globals;
import 'package:cookit/model/recipe.dart';
import 'content.dart';
import 'dashboard.dart';

class Searching extends StatefulWidget {
  @override
  _SearchingState createState() => _SearchingState();
}

class _SearchingState extends State<Searching> {
  FocusNode focusNode = new FocusNode();
  var queryResults = [];
  var tempStorage = [];

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
  }

  startSearch(String query) {
//    print('method chala');
    print(query);

    if (query.length == 0) {
      setState(() {
        queryResults = [];
        tempStorage = [];
      });
    }
    var searchQuery = query.substring(0, 1).toUpperCase() + query.substring(1);
    if (queryResults.length == 0 && searchQuery.length == 1) {
//      print('condition if');
      SearchService().search(searchQuery).then((QuerySnapshot querySnapshot) {
        print(querySnapshot.documents.length);
        for (int i = 0; i < querySnapshot.documents.length; i++) {
          queryResults.add(querySnapshot.documents[i].data);
          print(queryResults.length);
        }
        queryResults.forEach((result) {
          if (result['name'].toLowerCase().startsWith(searchQuery.toLowerCase())) {
            setState(() {
              tempStorage.add(result);
              print(tempStorage.length);
            });
          }
        });
      });
    } else {
//      print('condition else');
      tempStorage = [];
      queryResults.forEach((result) {
        if (result['name'].toLowerCase().startsWith(searchQuery.toLowerCase())) {
          setState(() {
            tempStorage.add(result);
            print(tempStorage.length);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
            child: Scaffold(
              backgroundColor:
                  globals.darkModeOn ? Colors.grey[800] : Colors.white,
              body: GestureDetector(
                onTap: () {
                  focusNode.unfocus();
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                        height: SizeConfig.height(50),
                        width: MediaQuery.of(context).size.width -
                            SizeConfig.width(20),
                        margin: EdgeInsets.only(
                            left: SizeConfig.width(10),
                            right: SizeConfig.width(10),
                            top: SizeConfig.height(10)),
                        decoration: BoxDecoration(
                          color: globals.darkModeOn
                              ? Colors.grey[800]
                              : Colors.white,
                        ),
                        child: Card(
                          color:
                              globals.darkModeOn ? Colors.grey : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 20,
                          child: TextField(
                            focusNode: focusNode,
                            onChanged: (searchValue) {
                              print(searchValue);
                              startSearch(searchValue);
                            },
                            onTap: () {
//                      print("value of isSearching : " + isSearching.toString());
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 3 * SizeConfig.heightMultiplier,
                                ),
                                border: InputBorder.none,
                                hintText: "Search here",
                                hintStyle: TextStyle(
                                  color: globals.darkModeOn
                                      ? Colors.white
                                      : Colors.grey[500],
                                )),
                            style: TextStyle(
                                color: globals.darkModeOn
                                    ? Colors.white
                                    : Colors.grey[500],
                                fontSize: 20,
                                fontFamily: "Livvic"),
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.height(100)),
                      height: SizeConfig.height(750),
                      width: MediaQuery.of(context).size.width,
                      child: ListView(
                        children: tempStorage.map((value) {
                          return Container(
                            width:SizeConfig.width(330),
                              height: SizeConfig.height(60),
                              padding: EdgeInsets.only(
                                  left: SizeConfig.width(20),
                                  top: SizeConfig.height(20)),
                              decoration: BoxDecoration(
                                color: globals.darkModeOn
                                    ? Colors.grey[800]
                                    : Colors.white,
                              ),
                              child: FlatButton(
                                onPressed: () {
                                  globals.selectedRecipe = new Recipe(
                                      value['name'],
                                      value['chef_name'],
                                      value['reference'],
                                      value['imageUrl'],
                                      value['ingredients'],
                                      value['chef_dp'],
                                      value['recipe']);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Content()));
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.arrow_forward,
                                      color: globals.darkModeOn
                                          ? Colors.orange
                                          : Colors.grey,
                                      size: 24,
                                    ),
                                    SizedBox(
                                      width: SizeConfig.width(15),
                                    ),
                                    Container(
                                      width: SizeConfig.width(330),
                                      child: Text(
                                        value['name'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: "Livvic",
                                          color: globals.darkModeOn
                                              ? Colors.white
                                              : Colors.grey,
                                        ),softWrap: true,
                                        textAlign: TextAlign.start,
                                      ),
                                    )
                                  ],
                                ),
                              ));
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            left: true,
            top: true,
            right: true,
            bottom: true);
  }
}
