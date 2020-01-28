import 'package:mi_sueldo/services/dailySalary.dart';

class Salary {
  int fixedAmount = 0;
  String firstDate;
  String lastDate;
  String title;
  String description;
  double totalSalary = 0;

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
