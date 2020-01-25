import 'package:mi_sueldo/services/Salary.dart';
import 'package:mi_sueldo/services/myTymer.dart';

class DailySalary extends Salary {
  MyTimer timer;
  String timeStarted;
  String timeEnded;
  String currentDate;
  int salaryPerHour;
  double currentSalary;

  DailySalary(salaryPerHour) {
    this.salaryPerHour = salaryPerHour;
    this.currentDate = timer.getDate();
    this.timeStarted = timer.getTime();
  }

  void finishDayWork() {
    timeEnded = timer.getTime();
  }

  void updateSalary() {
    currentSalary = salaryPerHour * 1.0;
  }
}
