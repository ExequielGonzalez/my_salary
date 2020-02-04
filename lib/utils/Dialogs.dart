import 'package:flutter/material.dart';
import 'package:mi_sueldo/utils/SharedPreferences.dart';

import 'Strings.dart';

Widget aboutInformation(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: AboutListTile(
          dense: true,
          icon: Icon(Icons.info),
          child: Text("Información"),
          aboutBoxChildren: <Widget>[
            Text("Aplicación desarrollada por Gonzalez Exequiel"),
            Text('Contacto: gonzalez-exequiel@hotmail.com'),
          ],
          applicationIcon: Image.asset(
            'assets/logo.png',
            fit: BoxFit.contain,
            width: 100,
          ),
          applicationLegalese: '© 2020 All rights reserved',
          applicationName: "Mi sueldo",
          applicationVersion: "$version",
        ),
      );
    },
  );
}
