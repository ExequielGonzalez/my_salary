import 'package:mi_sueldo/services/Salary.dart';
import 'package:mi_sueldo/services/myTymer.dart';

import 'dart:async';

import 'package:hive/hive.dart';

part 'dailySalary.g.dart';

@HiveType(typeId: 1)
class DailySalary extends Salary {
  @HiveField(7)
  String timeStarted; //!
  @HiveField(8)
  String timeEnded = ''; //!
  @HiveField(9)
  String currentDate; //!
  @HiveField(10)
  int salaryPerHour; //!
  @HiveField(11)
  double currentSalary = 0; //!
  @HiveField(12)
  int secondsWorked = 0; //!
  Timer _internalTimer;
  MyTimer _timer;
  @HiveField(15)
  bool isFinished = false;

  DailySalary(this.salaryPerHour) {
    _timer = MyTimer();
    this.timeEnded = 'En curso...';
    if (secondsWorked == 0 && isFinished == false) {
      _internalTimer = Timer.periodic(Duration(seconds: 1), (t) {
        secondsWorked += 1;
      });
      // this.salaryPerHour = salaryPerHour;
      this.currentDate = _timer.getDate();
      this.timeStarted = _timer.getTime();
      this.firstDate = _timer.getDateUnformatted();
    }
  }
  void finishDayWork() {
    if (!isFinished) {
      _internalTimer.cancel();
      timeEnded = _timer.getTime();
    }
    isFinished = true;
  }

  void updateSalary() {
    currentSalary = (secondsWorked * salaryPerHour) / 3600;
    // currentSalary = currentSalary - currentSalary % 0.01;//truncar a la segunda cifra
    currentSalary = (currentSalary * 100).round().toDouble() /
        100; //redondear a la segunda cifra.
    //En este caso se redondea a dos cifras porque se agrego un 100, si se quieren 3 cifras hay que usar 1000 en su lugar
  }

  int secondsTotalWorked() {
    if (this.timeEnded == 'En curso...')
      return secondsBetweenTwoTimes(this.timeStarted, _timer.getTime());
    else
      return secondsBetweenTwoTimes(this.timeStarted, this.timeEnded);
  }

  void setSecondsWorked() {
    this.secondsWorked =
        secondsBetweenTwoTimes(this.timeStarted, _timer.getTime());
  }

  double getSalary() //!esto es un prueba
  {
    if (!isFinished) {
      int sec =
          (DateTime.now()).difference(DateTime.parse(this.firstDate)).inSeconds;
      print('pasaron $sec segundos');
      currentSalary = (sec * salaryPerHour) / 3600;
      currentSalary = (currentSalary * 100).round().toDouble() /
          100; //redondear a la segunda cifra.
      //En este caso se redondea a dos cifras porque se agrego un 100, si se quieren 3 cifras hay que usar 1000 en su lugar
      print('el salario total es: $currentSalary');
    }
    return currentSalary;
  }
}

// void updateTime() {
//   Timer.periodic(Duration(seconds: interval), (timer) {
//     DateTime time = DateTime.parse(DateTime.now().toString());
//     timeUpdated = DateFormat.Hms().format(time);
//   });
// }
