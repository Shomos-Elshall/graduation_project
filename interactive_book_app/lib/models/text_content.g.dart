// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_content.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TextContentAdapter extends TypeAdapter<TextContent> {
  @override
  final int typeId = 6;

  @override
  TextContent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TextContent(
      en: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TextContent obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.en);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
