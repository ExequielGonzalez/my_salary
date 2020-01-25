import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class myTimer {
  myTimer({this.interval});

  int interval;
  String timeUpdated = DateTime.now().toString();

  void updateTime() {
    Timer.periodic(Duration(seconds: interval), (timer) {
      DateTime time = DateTime.parse(DateTime.now().toString());
      timeUpdated = DateFormat.Hms().format(time);
    });
  }
}
