import 'package:mi_sueldo/services/Salary.dart';
import 'package:mi_sueldo/services/myTymer.dart';

import 'dart:async';

class DailySalary extends Salary {
  MyTimer timer;
  String timeStarted; //!
  String timeEnded = 'En curso...'; //!
  String currentDate; //!
  int salaryPerHour; //!
  double currentSalary = 0; //!
  int secondsWorked = 0; //!
  Timer internalTimer;

  DailySalary(salaryPerHour) {
    timer = MyTimer();
    internalTimer = Timer.periodic(Duration(seconds: 1), (t) {
      secondsWorked += 1;
    });
    this.salaryPerHour = salaryPerHour;
    this.currentDate = timer.getDate();
    this.timeStarted = timer.getTime();
  }

  void finishDayWork() {
    internalTimer.cancel();
    timeEnded = timer.getTime();
  }

  void updateSalary() {
    currentSalary = (secondsWorked * salaryPerHour) / 3600;
    // currentSalary = currentSalary - currentSalary % 0.01;//truncar a la segunda cifra
    currentSalary = (currentSalary * 100).round().toDouble() /
        100; //redondear a la segunda cifra.
    //En este caso se redondea a dos cifras porque se agrego un 100, si se quieren 3 cifras hay que usar 1000 en su lugar
  }
}

// void updateTime() {
//   Timer.periodic(Duration(seconds: interval), (timer) {
//     DateTime time = DateTime.parse(DateTime.now().toString());
//     timeUpdated = DateFormat.Hms().format(time);
//   });
// }
