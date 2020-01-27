import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class MyTimer {
  MyTimer();
  String timeUpdated = DateTime.now().toString();

  // void updateTime() {
  //   Timer.periodic(Duration(seconds: interval), (timer) {
  //     DateTime time = DateTime.parse(DateTime.now().toString());
  //     timeUpdated = DateFormat.Hms().format(time);
  //   });
  // }

  String getDate() {
    return DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
  }

  String getTime() {
    return DateFormat.Hms().format(DateTime.now()).toString();
  }
}
