import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mi_sueldo/services/dailySalary.dart';
import 'package:mi_sueldo/services/Salary.dart';
import 'package:mi_sueldo/utils/SharedPreferences.dart';
import 'package:mi_sueldo/utils/DataBaseHandler.dart';
import 'package:mi_sueldo/utils/Strings.dart';

class Month extends StatefulWidget {
  @override
  _MonthState createState() => _MonthState();
}

class _MonthState extends State<Month> {
  final _formKey = GlobalKey<FormState>(); //para el popup

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
  var activeIndex;
  //variable usada para saber si la app se cerró mientras contaba

  bool showMonthHelp = true;

  ScrollController _scrollController =
      new ScrollController(); //para poner la list siempre on top cuando hay un nuevo item

  void updateEverything() {
    print('isStarted : $isStarted');
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (isStarted) {
        setState(() {
          // currentSalary.last().updateSalary();//!PRUEBA
          // currentSalary.last().getSalary();
          currentSalary.getTotalSalary();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    // print('build');
    currentSalary = ModalRoute.of(context).settings.arguments;

    return WillPopScope(
      onWillPop: () {
        if (isStarted == true)
          addBoolToSharedPreference('wasStarted', true);
        else {
          addBoolToSharedPreference('wasStarted', false);
        }
        Navigator.pop(context, currentSalary);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
            title: Text('${currentSalary.title}'),
            // backgroundColor: Theme.of(context).primaryColorDark,
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
            // Text('\$${currentSalary.getTotalSalary().toString()}'),
            Container(
              width: width * 0.95,
              height: height * 0.07,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _labelTotalSalay(context),
              ),
            ),
            Divider(
              height: 50,
              color: Theme.of(context).accentColor,
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                addRepaintBoundaries: true,
                // scrollDirection: Axis.vertical,
                // reverse: true, //la mas nueva arriba
                addAutomaticKeepAlives: true,

                shrinkWrap: true,
                itemCount: currentSalary.length(),
                itemBuilder: (context, index) {
                  // TODO:metodo para mostrar los ingresos diarios
                  return Card(
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: width * 0.22,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  '\$ ${currentSalary.index(index).currentSalary.toString()}', //acá
                                  style: TextStyle()),
                            )),
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
                            if (currentSalary.index(index).isFinished) {
                              //no se puede borrar si esta activo
                              setState(() {
                                currentSalary.remove(index);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(
              height: 5,
              color: Theme.of(context).accentColor,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
              child: Row(
                //!salario monto fijo
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          // icon: Icon(Icons.monetization_on),
                          hintText: '${currentSalary.fixedAmount}',
                          helperText: 'Salario monto fijo (Opcional)',
                          helperStyle: Theme.of(context).textTheme.caption,
                          border: OutlineInputBorder(),
                        ),
                        // onChanged: (text) {
                        //   currentSalary.fixedAmount = int.parse(text);
                        // },
                        onTap: () {
                          setState(() {
                            _updateInfoSalary(
                                context, 'Salario monto fijo (Opcional)');
                            currentSalary.getTotalSalary();
                          });
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        //!Salario por hora
                        keyboardType: TextInputType.number,

                        // autofocus: true,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            // icon: Icon(Icons.monetization_on),
                            // hintText: '${currentSalary.last().salaryPerHour}',
                            hintText: '${salaryPerHour}',
                            helperText: 'Salario por hora',
                            helperStyle: Theme.of(context).textTheme.caption,
                            border: OutlineInputBorder()),
                        // onChanged: (text) {
                        //   setState(() {
                        //     salaryPerHour = int.parse(text);
                        //   });
                        // },
                        onTap: () {
                          setState(() {
                            _updateInfoSalary(context, 'Salario por hora');
                          });
                          print('se ingresó: $salaryPerHour');
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: height * 0.1,
              width: width * 0.95,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: _startStopButton(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  void moveListItemToTop(_scrollController) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  Widget _updateInfoSalary(context, String toShow) {
    //TODO: IMPLEMENTAR
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
                        switch (toShow) {
                          case 'Salario por hora':
                            salaryPerHour = int.parse(text);
                            break;
                          case 'Salario monto fijo (Opcional)':
                            currentSalary.fixedAmount = int.parse(text);
                            break;
                        }
                      },
                      onFieldSubmitted: (asdas) {
                        setState(() {
                          switch (toShow) {
                            case 'Salario por hora':
                              print('se ingresó: $salaryPerHour');
                              break;
                            case 'Salario monto fijo (Opcional)':
                              print('se ingresó: ${currentSalary.fixedAmount}');
                              break;
                          }
                          Navigator.pop(context, []);
                        });
                      },
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: '$toShow',
                        labelStyle: Theme.of(context).textTheme.subhead,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            'Cancelar',
                            // style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              switch (toShow) {
                                case 'Salario por hora':
                                  salaryPerHour = 0;
                                  break;
                                case 'Salario monto fijo (Opcional)':
                                  currentSalary.fixedAmount = 0;
                                  break;
                              }
                              FocusScope.of(context).unfocus();
                              Navigator.pop(context, []);
                            }
                          },
                        ),
                        RaisedButton(
                            child: Text('Aceptar'),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                switch (toShow) {
                                  case 'Salario por hora':
                                    print('se ingresó: $salaryPerHour');
                                    break;
                                  case 'Salario monto fijo (Opcional)':
                                    print(
                                        'se ingresó: ${currentSalary.fixedAmount}');
                                    break;
                                }
                                FocusScope.of(context).unfocus();
                                Navigator.pop(context, []);
                              }
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
//    startStop = currentSalary.last().isFinished ? 'Empezar' : 'Finalizar';
    // print('InitState');
    checkSharedPreferences();
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    moveListItemToTop(_scrollController);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      salaryPerHour = currentSalary.last().salaryPerHour;
    });

    // });
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

  void checkSharedPreferences() async {
    wasStarted = await getBoolValuesSharedPreference('wasStarted');
    print('is working : $wasStarted');
    if (wasStarted ?? false) {
      isStarted = true;
      // currentSalary.last().setSecondsWorked();
      setState(() {
        startStop = isStarted ? 'Finalizar' : 'Empezar';
      });
    }
    activeIndex = await getIntValuesSharedPreference('index');
    showMonthHelp = await getBoolValuesSharedPreference('monthHelp');
    print('showMonthHelp $showMonthHelp');
    if (showMonthHelp) helpDialogMonth(context);

    updateEverything();
  }

  getIndexSalary() => getIntValuesSharedPreference('index');

  //!MOVER A utils/Dialogs.dart

  Widget helpDialogMonth(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$monthHelpTitle'),
          content: SingleChildScrollView(
            child: Container(
                child: Column(
              children: <Widget>[
                Text('$monthHelp'),
                Row(
                  children: <Widget>[
                    Checkbox(
                        value: showMonthHelp,
                        onChanged: (values) {
                          // print('click $values - showMonthHelp $showMonthHelp');
                          setState(() {
                            showMonthHelp = values;
                            print(
                                'click $values - showMonthHelp $showMonthHelp');
                            Navigator.pop(context);
                            helpDialogMonth(context);
                          });
                        }),
                    Text('No volver a mostrar este mensaje'),
                  ],
                )
              ],
            )),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cerrar'),
              onPressed: () {
                showMonthHelp = !showMonthHelp;
                print('se guardo en showMonthHelp: $showMonthHelp');
                addBoolToSharedPreference('monthHelp', showMonthHelp);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _labelTotalSalay(context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).accentColor,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      // color: Theme.of(context).cardColor,

      child: Center(
        child: Text(
          'Total: \$${currentSalary.totalSalary.toString()}',
          style: Theme.of(context).textTheme.title,
          // style: TextStyle(
          // letterSpacing: 2,
          // color: Colors.black,
          // fontSize: 20,
          // ),
        ),
      ),
    );
  }

  Widget _startStopButton(context) {
    print('se apretó el boton empezar');
    return RaisedButton(
      onPressed: () {
        if (!isStarted) {
          setState(() {
            print(
                'Se creo un nuevo dailySalary con un salario por hora de $salaryPerHour');
            income = DailySalary(salaryPerHour);
            currentSalary.addIncome(income);
          });
          // SchedulerBinding.instance.addPostFrameCallback((_) {
          moveListItemToTop(_scrollController);
          // });
          updateDataBase(activeIndex, currentSalary);
        } else {
          currentSalary.last().finishDayWork();
          // setState(() {
          //   currentSalary.getTotalSalary();
          // });
        }
        setState(() {
          isStarted = !isStarted;
          startStop = isStarted ? 'Finalizar' : 'Empezar';
        });
        if (isStarted == true)
          addBoolToSharedPreference('wasStarted', true);
        else {
          addBoolToSharedPreference('wasStarted', false);
        }
      },
      child:
          Text(startStop), //TODO: cambiar por el metodo empezar del a page home
      //!revisar en el github, la primer version
    );
  }
}
