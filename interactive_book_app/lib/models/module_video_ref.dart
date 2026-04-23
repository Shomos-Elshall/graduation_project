import 'dart:convert';

import 'package:hive/hive.dart';

part 'module_video_ref.g.dart';

@HiveType(typeId: 7)
class ModuleVideoRef extends HiveObject {
  @HiveField(0)
  final String source;

  @HiveField(1)
  final String? path;

  @HiveField(2)
  final String? payloadJson;

  ModuleVideoRef({
    required this.source,
    this.path,
    this.payloadJson,
  });

  Map<String, dynamic>? get payload =>
      payloadJson == null ? null : jsonDecode(payloadJson!) as Map<String, dynamic>;

  factory ModuleVideoRef.fromJson(Map<String, dynamic> json) {
    final source = (json['source'] as String?) ?? 'asset';
    return ModuleVideoRef(
      source: source,
      path: json['path'] as String?,
      payloadJson: json['payload'] != null ? jsonEncode(json['payload']) : null,
    );
  }
}
