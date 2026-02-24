import 'package:hive/hive.dart';
import 'package:interactive_book_app/models/text_content.dart';

part 'toc_model.g.dart';

@HiveType(typeId: 1)
class TocModel extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  int depth;

  @HiveField(5)
  List<TocModel> children;
  @HiveField(6)
  final TextContent? text;

  TocModel({
    required this.id,
    required this.name,
    required this.depth,
    required this.children,

    this.text,
  });

  factory TocModel.fromJson(Map<String, dynamic> json) {
    return TocModel(
      id: json['id'] as int,
      name: json['name'] as String,

      depth: json['depth'] as int,

      children:
          json['children'] != null
              ? (json['children'] as List)
                  .map(
                    (item) => TocModel.fromJson(item as Map<String, dynamic>),
                  )
                  .toList()
              : [],
      text:
          json['text'] != null
              ? TextContent.fromJson(json['text'] as Map<String, dynamic>)
              : null,
    );
  }
}
