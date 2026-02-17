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
      // parentId: fields[4] as int,
      // contentId: fields[3] as int,
      id: fields[0] as int,
      name: fields[1] as String,
      depth: fields[2] as int,
      children: (fields[5] as List).cast<TocModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, TocModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.depth)
      ..writeByte(3)
      // ..write(obj.contentId)
      ..writeByte(4)
      // ..write(obj.parentId)
      ..writeByte(5)
      ..write(obj.children);
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
