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
    totalSalary = 0;
    for (int i = 0; i < incomes.length; i++) {
      totalSalary += incomes[i].currentSalary;
    }
    totalSalary = totalSalary + fixedAmount;
    totalSalary = (totalSalary * 100).round().toDouble() /
        100; //redondear a la segunda cifra.
    //En este caso se redondea a dos cifras porque se agrego un 100, si se quieren 3 cifras hay que usar 1000 en su lugar
    return totalSalary;
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
}
