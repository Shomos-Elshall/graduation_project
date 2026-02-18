import 'package:hive/hive.dart';

part 'text_content.g.dart';

@HiveType(typeId: 6)
class TextContent {
  @HiveField(0)
  final String en;

  TextContent({required this.en});

  factory TextContent.fromJson(Map<String, dynamic> json) {
    return TextContent(en: json['en'] as String);
  }
}
