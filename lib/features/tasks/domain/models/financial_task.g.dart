// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FinancialTaskAdapter extends TypeAdapter<FinancialTask> {
  @override
  final int typeId = 1;

  @override
  FinancialTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinancialTask(
      id: fields[0] as String?,
      title: fields[1] as String,
      isCompleted: fields[2] as bool,
      dueDate: fields[3] as DateTime,
      priority: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FinancialTask obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.isCompleted)
      ..writeByte(3)
      ..write(obj.dueDate)
      ..writeByte(4)
      ..write(obj.priority);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinancialTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
