import 'package:hive/hive.dart';

part 'book_model.g.dart';
@HiveType(typeId: 0)
class BookModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String coverImageUrl;
  @HiveField(3)
  final String contentsURL;
  @HiveField(4)
  final String glossaryURL;

  BookModel({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    required this.contentsURL,
    required this.glossaryURL,
  });
}
