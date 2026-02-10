import 'package:hive/hive.dart';

part 'keyword_model.g.dart';

@HiveType(typeId: 5)
class KeywordModel extends HiveObject {
  @HiveField(0)
  final String word;

  @HiveField(1)
  final int? sectionId;

  @HiveField(2)
  final String bookId;

  @HiveField(3)
  final String? definition;

  @HiveField(4)
  final String? abbreviation;

  @HiveField(5)
  final String? objId;

  KeywordModel({
    required this.word,
    this.sectionId,
    required this.bookId,
    this.definition,
    this.abbreviation,
    this.objId,
  });
}
