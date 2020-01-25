import 'package:flutter/material.dart';
import 'package:mi_sueldo/services/myTymer.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String timeUpdated;
  bool isStarted = false;
  String startStop = 'empezar';
  Timer timer;
  int secondCounter = 0;
  int salaryPerHour = 100;
  double salary = 0;

  // myTimer timer = myTimer(interval: 1);

  void updateTime() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        timeUpdated = formatTime();
        secondCounter++;
      });
    });
  }

  String formatTime() {
    DateTime time = DateTime.parse(DateTime.now().toString());
    return DateFormat.Hms().format(time);
  }

  double getSalary() {
    return (secondCounter / 3600) * salaryPerHour;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber[100],
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          child: Text(
            '+',
            style: TextStyle(fontSize: 40),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/month');
          },
        ),
        appBar: AppBar(backgroundColor: Colors.redAccent, actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'configuración',
            onPressed: () {
              Navigator.pushNamed(context, '/config');
            },
          ),
        ]),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton.icon(
                onPressed: () {
                  setState(() {
                    isStarted = !isStarted;
                    startStop = isStarted ? 'finalizar' : 'empezar';
                  });
                  if (isStarted) {
                    updateTime();
                  } else {
                    timer.cancel();
                  }
                },
                label: Text(startStop),
                icon: Icon(Icons.update),
              ),
              Text(timeUpdated),
              SizedBox(height: 30),
              Text(secondCounter.toString()),
              SizedBox(height: 30),
              Text(getSalary().toString()),
            ],
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timeUpdated = formatTime();
  }
}
