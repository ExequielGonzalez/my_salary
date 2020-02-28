import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mi_sueldo/services/Salary.dart';
import 'package:mi_sueldo/utils/Dialogs.dart';
import 'package:mi_sueldo/utils/SharedPreferences.dart';
import 'package:mi_sueldo/utils/DataBaseHandler.dart';
import 'package:mi_sueldo/utils/Strings.dart';
import 'package:share/share.dart';
import 'package:mi_sueldo/utils/AdmobManager.dart';

class Home extends StatefulWidget {
  // final _adKey = GlobalKey(); //para el banner Ad
  @override
  // GlobalKey key = GlobalKey();
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>(); //para el popup

  ScrollController _scrollController =
      new ScrollController(); //para poner la list siempre on top cuando hay un nuevo item

  final String version = '1.1.2';

  String salaryTitle = '';
  String salaryDecription = '';

  List<Salary> salaries = [];

  Salary salary;

  Timer timer;

  bool isWorkingNow = false;
  int activeIndex = 0;

  String currentTimeWorked = '00:00:00';
  String currentSalaryReceived = '0.0';

  bool showHomeHelp;

  int timesAdSaw = 0; //para saber si tengo que mostrar un interstitial

  //!Para el menú
  CustomPopupMenu _selectedChoices = choices[0];

  AdmobManager adManager; //para mostrar anuncios

  //!Para el menú
  void _select(CustomPopupMenu choice) {
    setState(() {
      _selectedChoices = choice;
      print("Seleccionaste: ${_selectedChoices.title}");
      switch (_selectedChoices.title) {
        case '¿Que hay de nuevo?':
          showChangelog(context);
          break;
        case 'Información':
          aboutInformation(context);
          break;
        case 'Mostrar ayudas':
          addBoolToSharedPreference('monthHelp', true);
          addBoolToSharedPreference('homeHelp', true);
          helpDialogHome(context);
          break;
        case 'Compartir':
          share(context);
          break;
      }
    });
  }

  void updateEverything() {
    print('se llamo al update everything. is working $isWorkingNow');
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (salaries.isNotEmpty) {
        if (isWorkingNow) {
          print('isWorkingNow: $isWorkingNow - activeIndex: $activeIndex');
          if (salaries.isNotEmpty) {
            setState(() {
              currentSalaryReceived =
                  salaries[activeIndex].getTotalSalary().toString();
              currentTimeWorked =
                  salaries[activeIndex].getTotalTimeWorked().toString();
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //para que el boton de back no haga nada
      onWillPop: () {},
      child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: FloatingActionButton(
              elevation: 12,
              backgroundColor: Theme.of(context).accentColor,
              child: const Text(
                '+',
                style: const TextStyle(fontSize: 40),
              ),
              onPressed: () {
                //!!!!!!!!!!!!!!!!!!!!!
                _createNewSalary();
              },
            ),
          ),
          appBar: AppBar(
            title: const Text(
              'Mi Sueldo',
              style: TextStyle(fontFamily: 'RobotoSlab'),
            ),
            centerTitle: true,
            actions: <Widget>[
              callMenu(context),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: salaries.isEmpty ?? true
                      ? const Center(child: Text(''))
                      : _createSalaryList(),
                ),
              ),
              Container(
                //!Aca se muestra el banner
                height: 75,
                // child: const ShowAdBanner()
                // child: adManager.getBanner(),
                child: AdmobManager.banner,

                // ),
              ),
            ],
          )),
    );
  }

  Widget _createSalaryList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      controller: _scrollController,
      addRepaintBoundaries: true,
      addAutomaticKeepAlives: true,
      reverse: false,
      shrinkWrap: true,
      itemCount: salaries.length,
      itemBuilder: (context, index) {
        // focusColor(index);
        return Padding(
          padding: const EdgeInsets.fromLTRB(4, 3, 4, 0),
          child: Card(
            elevation: (index == activeIndex && isWorkingNow == true) ? 24 : 6,

            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: (index == activeIndex && isWorkingNow == true)
                    ? Theme.of(context).accentColor
                    : Theme.of(context).cardColor,
                width: 1,
              ),
              borderRadius: const BorderRadius.all(
                const Radius.circular(12.0),
              ),
            ),
            // color: (index == activeIndex && isWorkingNow == true)
            //     ? Theme.of(context).accentColor
            //     : Theme.of(context).cardColor,
            child: InkWell(
              highlightColor: Theme.of(context).accentColor,

              onLongPress: () {
                _deleteSalary(index);
              }, //!************Borrar Ingresos***************!
              onTap: () async {
                if (index != activeIndex && isWorkingNow) {
                  _errorActiveCounter();
                  //si hay un contador activo, pero en otro salario
                  print('Error: Hay un contador activo en otro salario');
                } else {
                  if (timesAdSaw % 2 == 0 && timesAdSaw != 0 ||
                      timesAdSaw == 1) {
                    adManager.loadAdvert(); //!Se crea el interstitial
                    timesAdSaw = timesAdSaw % 10;
                  } //mostrar el intestitial
                  timesAdSaw += 1;

                  addIntToSharedPreference('index', index);
                  dynamic result = await Navigator.of(
                          context) //se va a month con el salario elegido
                      .pushNamed('/month', arguments: salaries[index]);
                  salaries[index] =
                      result; //con esta linea se recibe lo de la page month
                  updateDataBase(index, salaries[index]);
                  checkSharedPreferences();
                  setState(() {
                    currentSalaryReceived =
                        salaries[activeIndex].getTotalSalary().toString();
                    currentTimeWorked =
                        salaries[activeIndex].getTotalTimeWorked();
                  });
                }
              },
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      //horas totales y salario total
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            // Text(''),
                            Text(
                                'Horas Totales: ${(index == activeIndex) ? currentTimeWorked : salaries[index].getTotalTimeWorked()}'),
                            Text(
                                'Salario Total: \$${(index == activeIndex) ? currentSalaryReceived : salaries[index].totalSalary.toString()}')
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      //Mostrar titulo y descripcion
                      flex: 4,
                      child: ListTile(
                        title: Text(salaries[index].title,
                            style: Theme.of(context).textTheme.headline5),
                        // onTap:
                        subtitle: Text(
                          salaries[index].description,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        // onLongPress:
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteSalary(index);
                        },
                      ),
                    ),
                  ],
                ),
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
                        labelStyle: Theme.of(context).textTheme.subtitle1,
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
                        labelStyle: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: const Text(
                        "Crear",
                      ),
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
                          moveListItemToTop(_scrollController);

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
                  const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text('¿Desea eliminar este ingreso?'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          child: const Text('Eliminar'),
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
                          child: const Text(
                            'Cancelar',
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
          title: const Text("Error: Ya hay un contador activo"),
          content: new Text(
              'En "${salaries[activeIndex].title}" ya hay un contador activo. Por favor termine ese antes de comenzar otro.'),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: const Text("Cerrar"),
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
          title: const Text("Error: No se puede eliminar"),
          content: Text(
              'No se puede eliminar "${salaries[activeIndex].title}" ya que en el hay un contador activo. Por favor termine este antes de eliminarlo.'),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: const Text("Cerrar"),
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
          content: SingleChildScrollView(
            child: Container(
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
                    const Text('No volver a mostrar este mensaje'),
                  ],
                ),
              ],
            )),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cerrar'),
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

  callMenu(context) {
    return PopupMenuButton<CustomPopupMenu>(
      elevation: 3.2,
      initialValue: choices[0],
      onCanceled: () {
        print('No seleccionaste nada del menú');
      },
      // tooltip: 'This is tooltip',
      onSelected: _select,
      itemBuilder: (BuildContext context) {
        return choices.map((CustomPopupMenu choice) {
          return PopupMenuItem<CustomPopupMenu>(
            value: choice,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    choice.icon,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Text(choice.title),
              ],
            ),
          );
        }).toList();
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
  }

  checkShowHomeHelp() async => await getBoolValuesSharedPreference('homeHelp');

  checkIfWasStarted() async =>
      await getBoolValuesSharedPreference('wasStarted');

  void moveListItemToTop(_scrollController) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  void moveListItemToActive(_scrollController) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      print('active index: $activeIndex');

      _scrollController.animateTo(
        activeIndex * 100.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  share(context) {
    // final RenderBox box = context.findRenderObject();
    final String link = 'https://cutt.ly/miSueldo';
    Share.share(
      '¡Proba la nueva version de Mi sueldo(v$version)! \nDescargala ya desde: $link',
    );
  }

  @override
  void initState() {
    adManager = AdmobManager.adManager;
    adManager.createAdvert(); //se debe iniciar el interstitial

    print('initState');
    // addIntToSharedPreference('index', 0);
    salaries = readListToTheDataBase();
    checkSharedPreferences();
    print('is working desde el init: $isWorkingNow');
    if (salaries.isNotEmpty) {
      currentSalaryReceived = salaries[activeIndex].getTotalSalary().toString();
      currentTimeWorked = salaries[activeIndex].getTotalTimeWorked();
      moveListItemToTop(_scrollController);
      // moveListItemToActive(_scrollController);
    } else
      addIntToSharedPreference('index', 0);

    super.initState();
  }

  void dispose() {
    print('dispose');
    if (isWorkingNow) timer.cancel();
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }
}

// getInterstitialAdUnitId() {
//   return 'ca-app-pub-3940256099942544/1033173712';
// }

String getBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/6300978111';
  }
  return null;
}
