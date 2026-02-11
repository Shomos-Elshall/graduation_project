// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_objects_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookObjectsAdapter extends TypeAdapter<BookObjects> {
  @override
  final int typeId = 4;

  @override
  BookObjects read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookObjects(
      id: fields[0] as String,
      title: fields[1] as String,
      language: fields[2] as String,
      url: fields[3] as String,
      h5pType: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookObjects obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.language)
      ..writeByte(3)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookObjectsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
