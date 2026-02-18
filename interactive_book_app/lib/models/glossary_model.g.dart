// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glossary_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GlossaryModelAdapter extends TypeAdapter<GlossaryModel> {
  @override
  final int typeId = 3;

  @override
  GlossaryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GlossaryModel(
      word: fields[0] as String,
      defination: fields[2] as String,
      abbreviation: fields[3] as String?,
      objId: fields[4] as String?,
      objTitle: fields[5] as String?,
      sectionIds: (fields[6] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, GlossaryModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(2)
      ..write(obj.defination)
      ..writeByte(3)
      ..write(obj.abbreviation)
      ..writeByte(4)
      ..write(obj.objId)
      ..writeByte(5)
      ..write(obj.objTitle)
      ..writeByte(6)
      ..write(obj.sectionIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GlossaryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
