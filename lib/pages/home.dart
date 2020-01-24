import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String timeUpdated = DateTime.now().toString();

  void updateTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timeUpdated = DateTime.now().toString();
      });
    });
  }

  // Timer.periodic(Duration(seconds:1),(timer){
  //   setState((){
  //     timeUpdated = DateTime.now().toString();
  //   });
  // });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(timeUpdated),
            ],
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateTime();
  }
}
