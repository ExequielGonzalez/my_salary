import 'package:flutter/material.dart';
import 'package:mi_sueldo/pages/home.dart';
import 'package:mi_sueldo/pages/starting.dart';
import 'package:mi_sueldo/pages/config.dart';
import 'package:mi_sueldo/pages/month.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData(),
      initialRoute: '/',
      routes: {
        '/': (context) => Starting(),
        '/home': (context) => Home(),
        '/config': (context) => Config(),
        '/month': (context) => Month(),
      },
    ));
