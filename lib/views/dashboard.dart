import 'package:cookit/util/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: true,
        top: true,
        right: true,
        left: true,
        child: WillPopScope(
          onWillPop: () {},
          child: Scaffold(
            body: Stack(
              children: [
                Container(
                  height: SizeConfig.height(50),
                  width: SizeConfig.width(383),
                  margin: EdgeInsets.only(left: SizeConfig.width(17),right: SizeConfig.width(17),top: SizeConfig.height(20)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: FlatButton(
                    onPressed: (){},
                    child: Row(
                      children: [
                        Icon(Icons.search),
                        Text('Search for reciepes and channels',style: TextStyle(color: Colors.grey),)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
