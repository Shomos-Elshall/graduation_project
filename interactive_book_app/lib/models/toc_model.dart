
import 'package:hive/hive.dart';

part 'toc_model.g.dart';

@HiveType(typeId: 1)
class TocModel extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  int depth;
  @HiveField(3)
  int ? contentId ;
  @HiveField(4)
  int ? parentId;
  @HiveField(5)
  List<TocModel> children;
 

  TocModel(
      this.parentId,
      this.contentId,
    {
    required this.id,
    required this.name,
    required this.depth,
    required this.children,
  }

  );

}
