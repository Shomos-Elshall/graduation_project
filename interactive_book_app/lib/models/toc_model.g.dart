// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toc_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TocModelAdapter extends TypeAdapter<TocModel> {
  @override
  final int typeId = 1;

  @override
  TocModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TocModel(
      id: fields[0] as int,
      name: fields[1] as String,
      depth: fields[2] as int,
      children: (fields[5] as List).cast<TocModel>(),
      text: fields[6] as TextContent?,
    );
  }

  @override
  void write(BinaryWriter writer, TocModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.depth)
      ..writeByte(5)
      ..write(obj.children)
      ..writeByte(6)
      ..write(obj.text);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TocModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
