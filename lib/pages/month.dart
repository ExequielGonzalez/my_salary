import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mi_sueldo/services/dailySalary.dart';
import 'package:mi_sueldo/services/Salary.dart';

class Month extends StatefulWidget {
  @override
  _MonthState createState() => _MonthState();
}

class _MonthState extends State<Month> {
  Salary currentSalary;

  // List<DailySalary> incomes = [];
  int salaryPerHour = 0;
  String currentDate;
  String timeStarted;

  Timer timer;
  bool isStarted = false;
  String startStop = 'empezar';
  int secondCounter = 0;

  DailySalary income; //aux variable

  void updateEverything() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (isStarted) {
        setState(() {
          currentSalary.last().updateSalary();
          currentSalary.getTotalSalary();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    currentSalary = ModalRoute.of(context).settings.arguments;
    salaryPerHour = currentSalary.last().salaryPerHour;

    return WillPopScope(
      onWillPop: () {}, //el boton back no hace nada
      child: Scaffold(
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Text('\$${currentSalary.getTotalSalary().toString()}'),
                  Container(
                    constraints: BoxConstraints(minWidth: 170, maxWidth: 300),
                    child: Text(
                      'Total: \$${currentSalary.getTotalSalary().toString()}',
                      style: TextStyle(
                        letterSpacing: 2,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (!isStarted) {
                        setState(() {
                          income = DailySalary(salaryPerHour);
                          currentSalary.addIncome(income);
                        });
                        // addDailySalaryToTheDataBase(income);//!..............
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
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
                child: Row(
                  //!salario monto fijo
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          icon: Icon(Icons.monetization_on),
                          hintText: '${currentSalary.fixedAmount}',
                          helperText: 'Salario monto fijo (Opcional)',
                          helperStyle: TextStyle(color: Colors.redAccent),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (text) {
                          currentSalary.fixedAmount = int.parse(text);
                        },
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        //!Salario por hora
                        keyboardType: TextInputType.number,
                        // autofocus: true,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            icon: Icon(Icons.monetization_on),
                            hintText: '${currentSalary.last().salaryPerHour}',
                            helperText: 'Salario por hora',
                            helperStyle: TextStyle(color: Colors.redAccent),
                            border: OutlineInputBorder()),
                        onChanged: (text) {
                          salaryPerHour = int.parse(text);
                        },
                      ),
                    ),
                  ],
                ),
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
          )),
    );
  }

  @override
  void initState() {
    updateEverything();
    // incomes = readListToTheDataBase();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    // Navigator.pop(context, currentSalary);
    currentSalary.last().finishDayWork();
    // TODO: implement dispose
    // final salaryBox = Hive.box('DailySalary');
    // salaryBox.clear();

    super.dispose();
  }

  void addDailySalaryToTheDataBase(DailySalary income) {
    // final salaryBox = Hive.box('DailySalary');
    // salaryBox.add(income);
    // salaryBox.
  }

  // List<DailySalary> readListToTheDataBase() {
  // List<DailySalary> auxList = [];
  // DailySalary auxSalary;
  // final salaryBox = Hive.box('DailySalary');
  // for (int i = 0; i < salaryBox.length; i++) {
  //   auxSalary = salaryBox.getAt(i);
  //   print(auxSalary.timeStarted);
  //   auxList.add(auxSalary);
  // }
  // return auxList;
  // }

  Future<bool> _onBackPressed() {
    // return Navigator.pop(context, currentSalary) ?? false;
    // return showDialog(
    //       context: context,
    //       builder: (context) => new AlertDialog(
    //         title: new Text('Are you sure?'),
    //         content: new Text('Do you want to exit an App'),
    //         actions: <Widget>[
    //           new GestureDetector(
    //             onTap: () => Navigator.of(context).pop(false),
    //             child: Text("NO"),
    //           ),
    //           SizedBox(height: 16),
    //           new GestureDetector(
    //             onTap: () => Navigator.of(context).pop(true),
    //             child: Text("YES"),
    //           ),
    //         ],
    //       ),
    //     ) ??
    //     false;
  }

  // void _moveToSignInScreen(BuildContext context) =>
  //     Navigator.pushReplacementNamed(context, '/home',
  //         arguments: currentSalary);

}
