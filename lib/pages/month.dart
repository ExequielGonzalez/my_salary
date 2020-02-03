import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mi_sueldo/services/dailySalary.dart';
import 'package:mi_sueldo/services/Salary.dart';
import 'package:mi_sueldo/utils/SharedPreferences.dart';
import 'package:mi_sueldo/utils/DataBaseHandler.dart';

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

  var wasStarted;
  var index;
  //variable usada para saber si la app se cerró mientras contaba

  void updateEverything() {
    print('isStarted : $isStarted');
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (isStarted) {
        print('aca no deberia estar entrando');
        setState(() {
          currentSalary.last().updateSalary();
          currentSalary.getTotalSalary();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('build');
    currentSalary = ModalRoute.of(context).settings.arguments;
    salaryPerHour = currentSalary.last().salaryPerHour;

    return WillPopScope(
      onWillPop: () {}, //el boton back no hace nada
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.amber[100],
          appBar: AppBar(
              title: Text('${currentSalary.title}'),
              backgroundColor: Colors.redAccent,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  if (isStarted == true)
                    addBoolToSharedPreference('wasStarted', true);
                  else {
                    addBoolToSharedPreference('wasStarted', false);
                  }
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
                    //Empezar
                    onPressed: () {
                      if (!isStarted) {
                        setState(() {
                          income = DailySalary(salaryPerHour);
                          currentSalary.addIncome(income);
                        });
                        updateDataBase(index, currentSalary);
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
                      if (isStarted == true)
                        addBoolToSharedPreference('wasStarted', true);
                      else {
                        addBoolToSharedPreference('wasStarted', false);
                      }
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
    // print('InitState');
    checkIfWasStarted();

    super.initState();
  }

  @override
  void dispose() {
    // print('dispose');
    timer.cancel();
    // Navigator.pop(context, currentSalary);
    // currentSalary.last().finishDayWork();
    // TODO: implement dispose
    // final salaryBox = Hive.box('DailySalary');
    // salaryBox.clear();
    // if (isStarted) {
    //   addBoolToSharedPreference('wasStarted', true);
    // }
    super.dispose();
  }

  void checkIfWasStarted() async {
    wasStarted = await getBoolValuesSharedPreference('wasStarted');
    print('is working : $wasStarted');
    if (wasStarted ?? false) {
      isStarted = true;
      currentSalary.last().setSecondsWorked();
      startStop = isStarted ? 'finalizar' : 'empezar';
    }
    index = await getIntValuesSharedPreference('index');
    updateEverything();
  }

  getIndexSalary() => getIntValuesSharedPreference('index');
}
