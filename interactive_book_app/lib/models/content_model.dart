import 'package:hive/hive.dart';
part 'content_model.g.dart';

@HiveType(typeId: 2)
class ContentModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int depth;
  @HiveField(3)
  final int? parentId;
  @HiveField(4)
  final String? textEn;
  @HiveField(5)
  final String? textAr;
  @HiveField(6)
  final String? audioEn;
  @HiveField(7)
  final String? audioAr;
  @HiveField(8)
  final List<String> kewordsWords;

  ContentModel({
    required this.id,
    required this.name,
    required this.depth,
    required this.parentId,
    required this.textEn,
    required this.textAr,
    required this.audioEn,
    required this.audioAr,
    required this.kewordsWords,
  });
}
