import 'package:hive/hive.dart';
part 'glossary_model.g.dart';

@HiveType(typeId: 3)
class GlossaryModel {
  @HiveField(0)
  final String word;
  @HiveField(1)
  final String bookId;
  @HiveField(2)
  final String defination;
  @HiveField(3)
  final String? abbreviation;
  @HiveField(4)
  final String? objId;
  @HiveField(5)
  final String? objTitle;
  @HiveField(6)
  final List<int> sectionIds;

  GlossaryModel({
    required this.word,
    required this.bookId,
    required this.defination,
    required this.abbreviation,
    required this.objId,
    required this.objTitle,
    required this.sectionIds,
  });

  factory GlossaryModel.fromJson(Map<String, dynamic> json) {
    return GlossaryModel(
      word: json['word'] as String,
      bookId: json['bookId'] as String,
      defination: json['defination'] as String,
      abbreviation: json['abbreviation'] as String?,
      objId: json['objId'] as String?,
      objTitle: json['objTitle'] as String?,
      sectionIds: (json['sectionIds'] as List).map((e) => e as int).toList(),
    );
  }
}
