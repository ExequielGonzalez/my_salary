import 'package:flutter/material.dart';
import 'package:mi_sueldo/pages/home.dart';
import 'package:mi_sueldo/pages/starting.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Starting(),
        '/home': (context) => Home(),
      },
    ));
