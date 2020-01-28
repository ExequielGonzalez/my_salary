import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mi_sueldo/services/dailySalary.dart';
import 'package:mi_sueldo/services/Salary.dart';

class Month extends StatefulWidget {
  @override
  _MonthState createState() => _MonthState();
}

class _MonthState extends State<Month> {
  Salary currentSalary;

  List<DailySalary> incomes = [];
  int salaryPerHour = 1;
  String currentDate;
  String timeStarted;

  Timer timer;
  bool isStarted = false;
  String startStop = 'empezar';
  int secondCounter = 0;

  DailySalary income; //aux variable

  void updateEverything() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        currentSalary.last().updateSalary();
        currentSalary.getTotalSalary();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    currentSalary = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        backgroundColor: Colors.amber[100],
        appBar: AppBar(
            title: Text('${currentSalary.title}'),
            backgroundColor: Colors.redAccent,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, currentSalary);
              },
            )),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // Text('\$${currentSalary.getTotalSalary().toString()}'),
                Text('\$${currentSalary.getTotalSalary().toString()}'),
                RaisedButton(
                  onPressed: () {
                    if (!isStarted) {
                      setState(() {
                        income = DailySalary(salaryPerHour);
                        currentSalary.addIncome(income);
                      });
                    } else {
                      currentSalary.last().finishDayWork();
                      // setState(() {
                      //   currentSalary.getTotalSalary();
                      // });
                    }
                    setState(() {
                      isStarted = !isStarted;
                      startStop = isStarted ? 'finalizar' : 'empezar';
                    });
                  },
                  child: Text(
                      startStop), //TODO: cambiar por el metodo empezar del a page home
                  //!revisar en el github, la primer version
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
                    onChanged: (text) {
                      currentSalary.fixedAmount = int.parse(text);
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
                    onChanged: (text) {
                      salaryPerHour = int.parse(text);
                    },
                  ),
                ),
              ],
            ),
            Divider(
              height: 50,
              color: Colors.redAccent,
            ),
            Flexible(
              child: ListView.builder(
                addRepaintBoundaries: true,
                scrollDirection: Axis.vertical,
                reverse: true, //la mas nueva arriba
                addAutomaticKeepAlives: true,

                shrinkWrap: true,
                itemCount: currentSalary.length(),
                itemBuilder: (context, index) {
                  // TODO:metodo para mostrar los ingresos diarios
                  return Card(
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: 100,
                            child: Text(
                                '\$ ${currentSalary.index(index).currentSalary}',
                                style: TextStyle())),
                        Expanded(
                          child: ListTile(
                            //  onTap: ,no es necesario que hagan nada cuando se presionen
                            // title: Text('${incomes[index].currentDate}'),
                            title: Text(
                                '${currentSalary.index(index).currentDate}'),
                            subtitle: Text(
                                '${currentSalary.index(index).timeStarted} - ${currentSalary.index(index).timeEnded}'),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              currentSalary.remove(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }

  @override
  void initState() {
    updateEverything();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    // Navigator.pop(context, currentSalary);
    // TODO: implement dispose
    super.dispose();
  }
}
