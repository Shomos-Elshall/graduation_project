// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyword_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KeywordModelAdapter extends TypeAdapter<KeywordModel> {
  @override
  final int typeId = 5;

  @override
  KeywordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KeywordModel(
      word: fields[0] as String,
      sectionId: fields[1] as int?,
      bookId: fields[2] as String,
      definition: fields[3] as String?,
      abbreviation: fields[4] as String?,
      objId: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, KeywordModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.sectionId)
      ..writeByte(2)
      ..write(obj.bookId)
      ..writeByte(3)
      ..write(obj.definition)
      ..writeByte(4)
      ..write(obj.abbreviation)
      ..writeByte(5)
      ..write(obj.objId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeywordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
