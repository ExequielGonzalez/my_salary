import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mi_sueldo/services/dailySalary.dart';

class Month extends StatefulWidget {
  @override
  _MonthState createState() => _MonthState();
}

class _MonthState extends State<Month> {
  List<DailySalary> incomes = [];
  int salaryPerHour;
  String currentDate;
  String timeStarted;

  Timer timer;
  bool isStarted = false;
  String startStop = 'empezar';
  int secondCounter = 0;

  DailySalary income; //aux variable

  void updateTime() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      incomes[incomes.length].updateSalary(secondCounter);
      setState(() {
        secondCounter++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber[100],
        appBar: AppBar(
          title: Text(
              'month'), //TODO:cambiar este nombre por la fecha de inicio y final
          backgroundColor: Colors.redAccent,
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(r'$XXXX'), //TODO: agregar el salario total acumulado
                RaisedButton(
                  onPressed: () {
                    income = DailySalary(
                        salaryPerHour); //TODO: agregar nuevos dias de trabajo
                    setState(() {
                      incomes.add(income);
                      isStarted = !isStarted;
                      startStop = isStarted ? 'finalizar' : 'empezar';
                    });
                    if (isStarted) {
                      updateTime();
                    } else {
                      timer.cancel();
                    }
                  },
                  child: Text(
                      startStop), //TODO: cambiar por el metodo empezar del a page home
                ),
              ],
            ),
            Row(
              //!salario monto fijo
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 200,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        icon: Icon(Icons.monetization_on),
                        // hintText: '...',
                        labelText: 'Salario monto fijo',
                        labelStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder()),
                    onSubmitted: (input) {
                      // salaryPerHour = int.parse(input);
                      // print(salaryPerHour);
                    },
                  ),
                ),
                Container(
                  width: 200,
                  child: TextField(
                    //!Salario por hora
                    keyboardType: TextInputType.number,
                    // autofocus: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        icon: Icon(Icons.monetization_on),
                        // hintText: '...',
                        labelText: 'Salario por hora',
                        labelStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder()),
                    onSubmitted: (input) {
                      // salaryPerHour = int.parse(input);
                      // print(salaryPerHour);
                    },
                  ),
                ),
                // RaisedButton(
                //   onPressed: () {},
                //   child: Text(
                //       'empezar'), //TODO: cambiar por el metodo empezar del a page home
                // ),
              ],
            ),
            Divider(
              height: 50,
              color: Colors.redAccent,
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: incomes.length,
              itemBuilder: (context, index) {
                // TODO:metodo para mostrar los ingresos diarios
                return Card(
                  child: Row(
                    children: <Widget>[
                      Text('\$ ${incomes[index].currentSalary}'),
                      ListTile(
                        //  onTap: ,no es necesario que hagan nada cuando se presionen
                        title: Text('${incomes[index].currentDate}'),
                        subtitle: Text(
                            '${incomes[index].timeStarted} - ${incomes[index].timeEnded}'),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            incomes.remove(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ));
  }
}
