import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mi_sueldo/utils/SharedPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Starting extends StatefulWidget {
  @override
  _StartingState createState() => _StartingState();
}

class _StartingState extends State<Starting> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitFadingCube(
              color: Theme.of(context).accentColor,
              size: 50.0,
            ),
            SizedBox(height: 30),
            Text(
              "Iniciando...",
              style: TextStyle(
                fontSize: 30,
                letterSpacing: 2,
                color: Theme.of(context).accentColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // removeValues('homeHelp');
    setSharedPreferences();
    // Future.delayed(const Duration(seconds: 0), () {
    //   //TODO:volver a 3 segundos
    //   Navigator.pushReplacementNamed(context, '/home');
    // });

    // TODO: implement initState
    super.initState();
  }

  void setSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // sharedPreferences.remove('monthHelp');
    // sharedPreferences.remove('homeHelp');
    // sharedPreferences.remove('index');
    // sharedPreferences.remove('wasStarted');

    if (!sharedPreferences.containsKey('index')) {
      print('Creando "index" en sharedPreferences');
      addIntToSharedPreference('index', 0);
    }
    if (!sharedPreferences.containsKey('wasStarted')) {
      print('Creando "wasStarted" en sharedPreferences');
      addBoolToSharedPreference('wasStarted', false);
    }
    if (!sharedPreferences.containsKey('homeHelp')) {
      print('Creando "homeHelp" en sharedPreferences');
      addBoolToSharedPreference('homeHelp', true);
    }
    if (!sharedPreferences.containsKey('monthHelp')) {
      print('Creando "monthHelp" en sharedPreferences');
      addBoolToSharedPreference('monthHelp', true);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
