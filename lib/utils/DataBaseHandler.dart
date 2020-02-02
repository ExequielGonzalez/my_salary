import 'package:hive/hive.dart';
import 'package:mi_sueldo/services/Salary.dart';

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
