import 'dart:io';

/** 
//TODO: Dark mode
//TODO: Poder tener mas de un contador activo, aunque solo uno por salario
//TODO: exportar a CSV la informacion
*/
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:mi_sueldo/pages/home.dart';
import 'package:mi_sueldo/pages/starting.dart';
import 'package:mi_sueldo/pages/config.dart';
import 'package:mi_sueldo/pages/month.dart';

import 'package:mi_sueldo/services/Salary.dart';
import 'package:mi_sueldo/services/dailySalary.dart';
import 'package:mi_sueldo/services/myTymer.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:mi_sueldo/services/dailySalary.g.dart';

// void main() => runApp(MaterialApp(
// theme: ThemeData(),
// initialRoute: '/',
// routes: {
//   '/': (context) => Starting(),
//   '/home': (context) => Home(),
//   '/config': (context) => Config(),
//   '/month': (context) => Month(),
// },
//     ));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(DailySalaryAdapter());
  Hive.registerAdapter(SalaryAdapter());
  Hive.registerAdapter(MyTimerAdapter());
  // await Hive.openBox('DailySalary');
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  // Admob.initialize(getAppId());

  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({Key key, this.sharedPreferences})
      : assert(sharedPreferences != null),
        super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildTheme(),
      // initialRoute: '/',
      routes: {
        // '/': (context) => Starting(),
        '/home': (context) => Home(),
        '/config': (context) => Config(),
        '/month': (context) => Month(),
      },
      home: FutureBuilder(
        future: Hive.openBox('Salary'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError)
              return Text(snapshot.error.toString());
            else
              return Home();
          }
          // Although opening a Box takes a very short time,
          // we still need to return something before the Future completes.
          else
            return Starting();
        },
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  ThemeData _buildTheme() {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      textTheme: _buildMyTextTheme(base.textTheme),
      primaryTextTheme: _buildMyTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildMyTextTheme(base.accentTextTheme),
      brightness: Brightness.dark,
      primaryColorDark: Colors.grey[900],
      primaryColor: Colors.orange[200],
      accentColor: Colors.amber[200],
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.amber[200],
        textTheme: ButtonTextTheme.primary,
      ),
      appBarTheme: AppBarTheme(
        elevation: 6,
        color: Colors.grey[900],
        textTheme: TextTheme(
          title: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 6,
        shape: RoundedRectangleBorder(
          // side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
      ),
    );
  }

  TextTheme _buildMyTextTheme(TextTheme base) {
    return base
        .copyWith(
          headline: base.headline
              .copyWith(fontSize: 20.0, fontWeight: FontWeight.w500),
          title: base.title.copyWith(
              fontSize: 18.0, fontWeight: FontWeight.w400, letterSpacing: 2),
          subhead: base.subhead
              .copyWith(fontSize: 16.0, fontWeight: FontWeight.w400),
          body1:
              base.body1.copyWith(fontSize: 14.0, fontWeight: FontWeight.w400),
          body2:
              base.body2.copyWith(fontSize: 14.0, fontWeight: FontWeight.w500),
          caption: base.caption.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 12.0,
          ),
        )
        .apply(
          displayColor: Colors.white,
          bodyColor: Colors.white,
        );
  }
}

String getAppId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544~1458002511';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544~3347511713';
  }
  return null;
}
