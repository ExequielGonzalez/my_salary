import 'package:flutter/material.dart';

class Config extends StatefulWidget {
  @override
  _ConfigState createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  int salaryPerHour = 0;
  String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Información'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            AboutListTile(
              icon: FlutterLogo(),
              child: Text("About"),
              aboutBoxChildren: <Widget>[
                Text("Playground app for Flutter. Contains list of examples."),
              ],
              applicationIcon: FlutterLogo(),
              applicationName: "Flutter Playground",
              applicationVersion: "1.0.0",
            ),
          ],
        ),
      ),
      // body: Center(
      //     child: Column(
      //   children: <Widget>[
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(40.0, 150, 40, 0),
      //       child: TextField(
      //         keyboardType: TextInputType.number,
      //         autofocus: true,
      //         textAlign: TextAlign.center,
      //         decoration: InputDecoration(
      //             icon: Icon(Icons.monetization_on),
      //             // hintText: '...',
      //             labelText: 'Salario por hora',
      //             labelStyle: TextStyle(color: Colors.redAccent),
      //             border: OutlineInputBorder()),
      //         onSubmitted: (input) {
      //           salaryPerHour = int.parse(input);
      //           print(salaryPerHour);
      //         },
      //       ),
      //     ),
      //   ],
      // )),
    );
  }
}
