// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContentModelAdapter extends TypeAdapter<ContentModel> {
  @override
  final int typeId = 2;

  @override
  ContentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContentModel(
      id: fields[0] as int,
      name: fields[1] as String,
      depth: fields[2] as int,
      parentId: fields[3] as int?,
      textEn: fields[4] as String?,
      textAr: fields[5] as String?,
      audioEn: fields[6] as String?,
      audioAr: fields[7] as String?,
      keywords: (fields[8] as List).cast<GlossaryModel>(),
      moduleVideo: fields[9] as ModuleVideoRef?,
    );
  }

  @override
  void write(BinaryWriter writer, ContentModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.depth)
      ..writeByte(3)
      ..write(obj.parentId)
      ..writeByte(4)
      ..write(obj.textEn)
      ..writeByte(5)
      ..write(obj.textAr)
      ..writeByte(6)
      ..write(obj.audioEn)
      ..writeByte(7)
      ..write(obj.audioAr)
      ..writeByte(8)
      ..write(obj.keywords)
      ..writeByte(9)
      ..write(obj.moduleVideo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
