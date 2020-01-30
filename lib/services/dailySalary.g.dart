// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dailySalary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailySalaryAdapter extends TypeAdapter<DailySalary> {
  @override
  final typeId = 1;

  @override
  DailySalary read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailySalary(
      fields[10] as int,
    )
      ..timeStarted = fields[7] as String
      ..timeEnded = fields[8] as String
      ..currentDate = fields[9] as String
      ..currentSalary = fields[11] as double
      ..secondsWorked = fields[12] as int
      ..fixedAmount = fields[0] as int
      ..firstDate = fields[1] as String
      ..lastDate = fields[2] as String
      ..title = fields[3] as String
      ..description = fields[4] as String
      ..totalSalary = fields[5] as double
      ..incomes = (fields[6] as List)?.cast<DailySalary>();
  }

  @override
  void write(BinaryWriter writer, DailySalary obj) {
    writer
      ..writeByte(13)
      ..writeByte(7)
      ..write(obj.timeStarted)
      ..writeByte(8)
      ..write(obj.timeEnded)
      ..writeByte(9)
      ..write(obj.currentDate)
      ..writeByte(10)
      ..write(obj.salaryPerHour)
      ..writeByte(11)
      ..write(obj.currentSalary)
      ..writeByte(12)
      ..write(obj.secondsWorked)
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
