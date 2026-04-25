import 'package:hive/hive.dart';
import 'package:interactive_book_app/models/glossary_model.dart';
import 'package:interactive_book_app/models/module_video_ref.dart';
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
  final List<GlossaryModel> keywords;
  @HiveField(9)
  final ModuleVideoRef? moduleVideo;

  ContentModel({
    required this.id,
    required this.name,
    required this.depth,
    required this.parentId,
    required this.textEn,
    required this.textAr,
    required this.audioEn,
    required this.audioAr,
    required this.keywords,
    this.moduleVideo,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    // أولاً نسحب الـ object اللي اسمه text
    final textMap = json['text'] as Map<String, dynamic>?;

    return ContentModel(
      id: json['id'] as int,
      name: json['name'] as String,
      depth: json['depth'] as int,
      parentId: json['parentId'] ?? 0,
      // هنا التعديل: ندخل جوه الـ textMap ونجيب en و ar
      textEn: textMap != null ? textMap['en'] : null,
      textAr: textMap != null ? textMap['ar'] : null,
      // نفس الكلام للـ audio لو محتاجاه
      audioEn: json['audio'] != null ? json['audio']['en'] : null,
      audioAr: json['audio'] != null ? json['audio']['ar'] : null,
      keywords:
          (json['keywords'] as List<dynamic>?)
              ?.map((e) => GlossaryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      moduleVideo: json['moduleVideo'] != null
          ? ModuleVideoRef.fromJson(json['moduleVideo'] as Map<String, dynamic>)
          : null,
    );
  }
}
