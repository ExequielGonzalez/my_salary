// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Salary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SalaryAdapter extends TypeAdapter<Salary> {
  @override
  final typeId = 0;

  @override
  Salary read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Salary(
      title: fields[3] as String,
      description: fields[4] as String,
    )
      ..fixedAmount = fields[0] as int
      ..firstDate = fields[1] as String
      ..lastDate = fields[2] as String
      ..totalSalary = fields[5] as double
      ..incomes = (fields[6] as List)?.cast<DailySalary>();
  }

  @override
  void write(BinaryWriter writer, Salary obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.fixedAmount)
      ..writeByte(1)
      ..write(obj.firstDate)
      ..writeByte(2)
      ..write(obj.lastDate)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.totalSalary)
      ..writeByte(6)
      ..write(obj.incomes);
  }
}
