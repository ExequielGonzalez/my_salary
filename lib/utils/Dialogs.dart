import 'package:flutter/material.dart';
import 'package:mi_sueldo/utils/SharedPreferences.dart';

import 'Strings.dart';

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon});

  String title;
  IconData icon;
}

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'Mostrar ayudas', icon: Icons.short_text),
  CustomPopupMenu(title: '¿Que hay de nuevo?', icon: Icons.help),
  CustomPopupMenu(title: 'Información', icon: Icons.info),
  CustomPopupMenu(title: 'Compartir', icon: Icons.share)
];

//!En vez de esto puedo llamar distintos dialog
// class SelectedOption extends StatelessWidget {
//   CustomPopupMenu choice;

//   SelectedOption({Key key, this.choice}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Icon(choice.icon, size: 140.0, color: Colors.white),
//             Text(
//               choice.title,
//               style: TextStyle(color: Colors.white, fontSize: 30),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

Widget showInformation(context) {}
//   String _selection;
//  return  PopupMenuButton<String>(
//     onSelected: (String value) {
//     setState(() {
//         _selection = value;
//     });
//   },
//   child: ListTile(
//     leading: IconButton(
//       icon: Icon(Icons.add_alarm),
//       onPressed: () {
//         print('Hello world');
//       },
//     ),
//     title: Text('Title'),
//     subtitle: Column(
//       children: <Widget>[
//         Text('Sub title'),
//         Text(_selection == null ? 'Nothing selected yet' : _selection.toString()),
//       ],
//     ),
//     trailing: Icon(Icons.account_circle),
//   ),
//   itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//         const PopupMenuItem<String>(
//           value: 'Value1',
//           child: Text('Choose value 1'),
//         ),
//         const PopupMenuItem<String>(
//           value: 'Value2',
//           child: Text('Choose value 2'),
//         ),
//         const PopupMenuItem<String>(
//           value: 'Value3',
//           child: Text('Choose value 3'),
//         ),
//       ],
// );

// showDialog(
//   context: context,
//   builder: (BuildContext context) {
//     return Dialog(
//       child: Column(
//         children: <Widget>[
//           aboutInformation(context),
//           changelog(context),
//         ],
//       ),
//     );
//   },
// );
// }

Widget aboutInformation(context) {
  showAboutDialog(
    context: context,
    applicationName: "Mi sueldo",
    applicationVersion: "$version",
    applicationLegalese: '© 2020 All rights reserved',
    applicationIcon: Image.asset(
      'assets/logo.png',
      fit: BoxFit.contain,
      width: 100,
    ),
    children: <Widget>[
      Text("Aplicación desarrollada por Gonzalez Exequiel"),
      Text('Contacto: gonzalez-exequiel@hotmail.com'),
    ],
  );
}

Widget showChangelog(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('¿Que hay de nuevo?'),
        content: SingleChildScrollView(child: Text('$changelog')),
        actions: <Widget>[
          FlatButton(
            child: Text('Cerrar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
