// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_video_ref.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModuleVideoRefAdapter extends TypeAdapter<ModuleVideoRef> {
  @override
  final int typeId = 7;

  @override
  ModuleVideoRef read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModuleVideoRef(
      source: fields[0] as String,
      path: fields[1] as String?,
      payloadJson: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ModuleVideoRef obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.source)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.payloadJson);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModuleVideoRefAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
