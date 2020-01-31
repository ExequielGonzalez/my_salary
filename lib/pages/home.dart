import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mi_sueldo/services/Salary.dart';
import 'package:mi_sueldo/services/myTymer.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>(); //para el popup

  final String version = '1.0.0';

  String salaryTitle = '';
  String salaryDecription = '';

  List<Salary> salaries = [];

  Salary salary;

  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
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
                  aboutInformation();
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
        return Padding(
          padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
          child: Card(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: ListTile(
                    title: Text(salaries[index].title),
                    onTap: () async {
                      //TODO: ver como ir a la pagina month
                      dynamic result = await Navigator.of(context)
                          .pushNamed('/month', arguments: salaries[index]);
                      salaries[index] =
                          result; //con esta linea se recibe lo de la page month
                      updateDataBase(index, salaries[index]);
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
                          'Horas totales: ${salaries[index].getTotalTimeWorked()}'),
                      Text(
                          'Salario Total: \$${salaries[index].getTotalSalary().toString()}')
                    ],
                  ),
                )
              ],
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
                              setState(() {
                                salaries.removeAt(index);
                                deleteSalaryFromDataBase(index);
                              });
                              Navigator.pop(context, []);
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

  Widget aboutInformation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: AboutListTile(
            icon: Icon(Icons.info),
            child: Text("Información"),
            aboutBoxChildren: <Widget>[
              Text("Aplicación desarrollada por Gonzalez Exequiel"),
              Text('Contacto: gonzalez-exequiel@hotmail.com'),
            ],
            applicationIcon: Image.asset(
              'assets/logo.png',
              width: 150,
            ),
            applicationLegalese: '© 2020 All rights reserved',
            applicationName: "Mi sueldo",
            applicationVersion: "$version",
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState

    salaries = readListToTheDataBase();
    super.initState();
  }

  void addSalaryToTheDataBase(Salary income) {
    final salaryBox = Hive.box('Salary');
    salaryBox.add(income);
  }

  void updateDataBase(index, Salary income) {
    final salaryBox = Hive.box('Salary');
    salaryBox.putAt(index, income);
  }

  void deleteSalaryFromDataBase(index) {
    final salaryBox = Hive.box('Salary');
    salaryBox.deleteAt(index);
  }

  List<Salary> readListToTheDataBase() {
    List<Salary> auxList = [];
    Salary auxSalary;
    final salaryBox = Hive.box('Salary');
    for (int i = 0; i < salaryBox.length; i++) {
      auxSalary = salaryBox.getAt(i);
      auxList.add(auxSalary);
    }
    return auxList;
  }
}
