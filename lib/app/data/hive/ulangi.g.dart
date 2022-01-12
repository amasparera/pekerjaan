// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ulangi.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UlangiAdapter extends TypeAdapter<Ulangi> {
  @override
  final int typeId = 1;

  @override
  Ulangi read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ulangi(
      (fields[0] as List).cast<DateTime>(),
      fields[1] as DateTime,
      (fields[2] as Map).cast<dynamic, dynamic>(),
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Ulangi obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.ulangan)
      ..writeByte(1)
      ..write(obj.update)
      ..writeByte(2)
      ..write(obj.model)
      ..writeByte(3)
      ..write(obj.idcategory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UlangiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
