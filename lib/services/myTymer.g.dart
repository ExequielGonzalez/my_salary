// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myTymer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyTimerAdapter extends TypeAdapter<MyTimer> {
  @override
  final typeId = 2;

  @override
  MyTimer read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyTimer()..timeUpdated = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, MyTimer obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.timeUpdated);
  }
}
