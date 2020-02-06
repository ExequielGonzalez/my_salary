import 'package:mi_sueldo/services/dailySalary.dart';

import 'package:hive/hive.dart';

part 'Salary.g.dart';

@HiveType(typeId: 0)
class Salary {
  @HiveField(0)
  int fixedAmount = 0;
  @HiveField(1)
  String firstDate;
  @HiveField(2)
  String lastDate;
  @HiveField(3)
  String title;
  @HiveField(4)
  String description;
  @HiveField(5)
  double totalSalary = 0;
  @HiveField(6)
  List<DailySalary> incomes = [];

  Salary({this.title, this.description}) {
    // this.title = title;
    // this.description = description;
  }

  void addIncome(DailySalary income) {
    incomes.add(income);
  }

  void removeIncome(DailySalary income) {
    incomes.remove(income);
  }

  double getTotalSalary() {
    //!PRUEBA, el de abajo funciona
    if (incomes.isNotEmpty) {
      totalSalary = 0;
      for (int i = 0; i < incomes.length; i++) {
        totalSalary += incomes[i].getSalary();
      }
      totalSalary = totalSalary + fixedAmount;
      totalSalary = (totalSalary * 100).round().toDouble() /
          100; //redondear a la segunda cifra.
      //En este caso se redondea a dos cifras porque se agrego un 100, si se quieren 3 cifras hay que usar 1000 en su lugar
      return totalSalary;
    } else
      return 0;
  }

  // double getTotalSalary() {
  //   if (incomes.isNotEmpty) {
  //     totalSalary = 0;
  //     for (int i = 0; i < incomes.length - 1; i++) {
  //       totalSalary += incomes[i].currentSalary;
  //     }
  //     if (!incomes.last.isFinished) incomes.last.updateSalary();
  //     totalSalary += incomes.last.currentSalary;
  //     totalSalary = totalSalary + fixedAmount;
  //     totalSalary = (totalSalary * 100).round().toDouble() /
  //         100; //redondear a la segunda cifra.
  //     //En este caso se redondea a dos cifras porque se agrego un 100, si se quieren 3 cifras hay que usar 1000 en su lugar
  //     return totalSalary;
  //   } else
  //     return 0;
  // }

  String getTotalTimeWorked() {
    int aux = 0;
    for (int i = 0; i < incomes.length; i++) {
      aux += incomes[i].secondsTotalWorked();
    }
    return _secondsToHour(aux);
  }

  DailySalary last() {
    if (incomes.isNotEmpty)
      return incomes.last;
    else
      return DailySalary(0);
  }

  int length() {
    if (incomes.isNotEmpty)
      return incomes.length;
    else
      return 0;
  }

  DailySalary index(index) {
    if (incomes.isNotEmpty)
      return incomes[index];
    else
      return DailySalary(0);
    ;
  }

  void remove(index) {
    if (incomes.isNotEmpty) incomes.removeAt(index);
  }

  String _hourBetweenTwoTimes(String time1, String time2) {
    int aux;
    aux = secondsBetweenTwoTimes(time1, time2);
    return _secondsToHour(aux);
  }

  int secondsBetweenTwoTimes(String time1, String time2) {
    int sec1 = _hourToSeconds(time1);
    int sec2 = _hourToSeconds(time2);
    if (sec1 <= sec2) {
      return sec2 - sec1;
    } else {
      return (sec2 + 86400) - sec1;
    }
  }

  int _hourToSeconds(String hour) {
    // if(hour!='En curso...'){
    //   List<String> aux = hour.split(':');
    //   return int.parse(aux[0]) * 3600 +
    //       int.parse(aux[1]) * 60 +
    //       int.parse(aux[2]);
    // }
    try {
      List<String> aux = hour.split(':');
      return int.parse(aux[0]) * 3600 +
          int.parse(aux[1]) * 60 +
          int.parse(aux[2]);
    } catch (e) {
      return 0;
    }
  }

  String _secondsToHour(int sec) {
    double h;
    double m;
    double s;
    int ha;
    int ma;
    int sa;
    h = (sec / 3600);
    m = (h - h.floor()) * 60;
    s = (m - m.floor()) * 60;
    s = s.round().toDouble();
    m = m.floor().toDouble();
    h = h.floor().toDouble();
    ha = h.toInt();
    ma = m.toInt();
    sa = s.toInt();
    // print('$ha:$ma:$sa');
    return ('$ha:$ma:$sa');
  }
}
