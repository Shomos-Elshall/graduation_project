// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookModelAdapter extends TypeAdapter<BookModel> {
  @override
  final int typeId = 0;

  @override
  BookModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookModel(
      id: fields[0] as String,
      title: fields[1] as String,
      coverPageURL: fields[2] as String,
      contentsURL: fields[3] as String,
      glossaryURL: fields[4] as String,
      authors: fields[5] as List<String>,
      toc: fields[6] as List<TocModel>,
      bookObjects: fields[7] as List<BookObjects>,
      contents: fields[8] as List<ContentModel>,
      glossary: fields[9] as List<GlossaryModel>,
    );
  }

  @override
  void write(BinaryWriter writer, BookModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.coverPageURL)
      ..writeByte(3)
      ..write(obj.contentsURL)
      ..writeByte(4)
      ..write(obj.glossaryURL)
      ..writeByte(5)
      ..write(obj.authors)
      ..writeByte(6)
      ..write(obj.toc)
      ..writeByte(7)
      ..write(obj.bookObjects)
      ..writeByte(8)
      ..write(obj.contents)
      ..writeByte(9)
      ..write(obj.glossary);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
