import 'package:flutter/material.dart';
import 'package:mi_sueldo/services/dailySalary.dart';

class Month extends StatefulWidget {
  @override
  _MonthState createState() => _MonthState();
}

class _MonthState extends State<Month> {
  List<DailySalary> incomes = DailySalary();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('month'),
      ),
    );
  }
}
