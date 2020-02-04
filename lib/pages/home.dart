import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mi_sueldo/services/Salary.dart';
import 'package:mi_sueldo/utils/Dialogs.dart';
import 'package:mi_sueldo/utils/SharedPreferences.dart';
import 'package:mi_sueldo/utils/DataBaseHandler.dart';
import 'package:mi_sueldo/utils/Strings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>(); //para el popup

  final String version = '1.1.0';

  String salaryTitle = '';
  String salaryDecription = '';

  List<Salary> salaries = [];

  Salary salary;

  Timer timer;

  bool isWorkingNow = false;
  int activeIndex = 0;
  Color listColor = Colors.white;

  String currentTimeWorked;
  String currentSalaryReceived;

  bool showHomeHelp;

  void updateEverything() {
    print('se llamo al update everything. is working $isWorkingNow');
    timer = Timer.periodic(Duration(seconds: 2), (t) {
      if (salaries.isNotEmpty) {
        if (isWorkingNow) {
          print('isWorkingNow: $isWorkingNow - activeIndex: $activeIndex');
          setState(() {
            currentSalaryReceived =
                salaries[activeIndex].getTotalSalary().toString();
            currentTimeWorked =
                salaries[activeIndex].getTotalTimeWorked().toString();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber[100],
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          child: Text(
            '+',
            style: TextStyle(fontSize: 40),
          ),
          onPressed: () {
            //!!!!!!!!!!!!!!!!!!!!!
            _createNewSalary();
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text('Mi Sueldo'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info_outline),
              tooltip: 'configuración',
              onPressed: () {
                setState(() {
                  aboutInformation(context);
                  // helpDialog(context);
                });
                // Navigator.pushNamed(context, '/config');
              },
            ),
          ],
        ),
        body: salaries?.isEmpty ?? true
            ? Center(child: Text(''))
            : _createSalaryList());
  }

  Widget _createSalaryList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      // shrinkWrap: true,
      itemCount: salaries.length,
      itemBuilder: (context, index) {
        // focusColor(index);
        return Padding(
          padding: const EdgeInsets.fromLTRB(4, 3, 4, 0),
          child: Card(
            child: Container(
              color: (index == activeIndex && isWorkingNow == true)
                  ? Colors.red[200]
                  : Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: ListTile(
                      title: Text(salaries[index].title),
                      onTap: () async {
                        if (index != activeIndex && isWorkingNow) {
                          _errorActiveCounter();
                          //si hay un contador activo, pero en otro salario
                          print(
                              'Error: Hay un contador activo en otro salario');
                        } else {
                          addIntToSharedPreference('index', index);
                          dynamic result = await Navigator.of(
                                  context) //se va a month con el salario elegido
                              .pushNamed('/month', arguments: salaries[index]);
                          salaries[index] =
                              result; //con esta linea se recibe lo de la page month
                          updateDataBase(index, salaries[index]);
                          checkSharedPreferences();
                          setState(() {
                            currentSalaryReceived = salaries[activeIndex]
                                .getTotalSalary()
                                .toString();
                            currentTimeWorked =
                                salaries[activeIndex].getTotalTimeWorked();
                          });
                          // else
                          //   timer.cancel();
                        }
                      },
                      subtitle: Text(salaries[index].description),
                      onLongPress: () {
                        _deleteSalary(index);
                      }, //!************Borrar Ingresos***************!
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        // Text(''),
                        Text(
                            'Horas totales: ${(index == activeIndex) ? currentTimeWorked : salaries[index].getTotalTimeWorked()}'),
                        Text(
                            'Salario Total: \$${(index == activeIndex) ? currentSalaryReceived : salaries[index].totalSalary.toString()}')
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _createNewSalary() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (text) {
                        salaryTitle = text;
                      },
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: 'Título',
                        labelStyle: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (text) {
                        salaryDecription = text;
                      },
                      keyboardType: TextInputType.text,
                      // autofocus: true,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        labelStyle: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text("Crear"),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          print('$salaryTitle - $salaryDecription');
                          setState(() {
                            salary = Salary(
                                title: salaryTitle,
                                description: salaryDecription);
                            salaries.add(salary);
                            addSalaryToTheDataBase(salary);
                          });
                          salaryTitle = '';
                          salaryDecription = '';
                          Navigator.pop(context, []);
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _deleteSalary(index) {
    //!**********Borrar Ingresos*****************!
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('¿Desea eliminar este ingreso?'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          child: Text('Eliminar'),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              if (isWorkingNow && index == activeIndex) {
                                Navigator.pop(context, []);
                                _errorDeleteActiveCounter(context);
                                // salaries[index].last().finishDayWork();
                                // addBoolToSharedPreference('wasStarted', false);
                              } else {
                                setState(() {
                                  salaries.removeAt(index);
                                  deleteSalaryFromDataBase(index);
                                });
                                Navigator.pop(context, []);
                              }
                            }
                          },
                        ),
                        RaisedButton(
                          child: Text(
                            'Cancelar',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              Navigator.pop(context, []);
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _errorActiveCounter() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error: Ya hay un contador activo"),
          content: new Text(
              'En "${salaries[activeIndex].title}" ya hay un contador activo. Por favor termine ese antes de comenzar otro.'),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _errorDeleteActiveCounter(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error: No se puede eliminar"),
          content: new Text(
              'No se puede eliminar "${salaries[activeIndex].title}" ya que en el hay un contador activo. Por favor termine ese antes de eliminarlo.'),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget helpDialogHome(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$homeHelpTitle'),
          content: Container(
              child: Column(
            children: <Widget>[
              Text('$homeHelp'),
              Row(
                children: <Widget>[
                  Checkbox(
                      value: showHomeHelp,
                      onChanged: (values) {
                        // print('click $values - showHomeHelp $showHomeHelp');
                        setState(() {
                          showHomeHelp = values;
                          print('click $values - showHomeHelp $showHomeHelp');
                          Navigator.pop(context);
                          helpDialogHome(context);
                        });
                      }),
                  Text('No volver a mostrar este mensaje'),
                ],
              ),
            ],
          )),
          actions: <Widget>[
            FlatButton(
              child: Text('Cerrar'),
              onPressed: () {
                showHomeHelp = !showHomeHelp;
                print('se guardo en showHomeHelp: $showHomeHelp');
                addBoolToSharedPreference('homeHelp', showHomeHelp);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void checkSharedPreferences() async {
    showHomeHelp = await checkShowHomeHelp();
    isWorkingNow = await checkIfWasStarted();
    print('is working : $isWorkingNow');
    if (isWorkingNow ?? false) {
      updateEverything();
      activeIndex = await getIntValuesSharedPreference('index');
    }
    print('aca showHomeHelp vale $showHomeHelp');
    if (showHomeHelp) helpDialogHome(context);
    setState(() {
      activeIndex;
    });
  }

  checkShowHomeHelp() async => await getBoolValuesSharedPreference('homeHelp');

  checkIfWasStarted() async =>
      await getBoolValuesSharedPreference('wasStarted');

  @override
  void initState() {
    // TODO: implement initState

    print('initState');

    // addIntToSharedPreference('index', 0);
    salaries = readListToTheDataBase();
    checkSharedPreferences();
    print('is working desde el init: $isWorkingNow');
    currentSalaryReceived = salaries[activeIndex].getTotalSalary().toString();
    currentTimeWorked = salaries[activeIndex].getTotalTimeWorked();
    super.initState();
  }

  void dispose() {
    print('dispose');
    if (isWorkingNow) timer.cancel();

    // Clean up the controller when the widget is disposed.
    super.dispose();
  }
}
