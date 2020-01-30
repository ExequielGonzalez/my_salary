import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

part 'myTymer.g.dart';

@HiveType(typeId: 2)
class MyTimer {
  @HiveField(0)
  String timeUpdated;

  MyTimer() {
    this.timeUpdated = DateTime.now().toString();
  }

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
