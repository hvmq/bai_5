import 'package:hive/hive.dart';
part 'story.g.dart';

@HiveType(typeId: 1)
class Story extends HiveObject {
  @HiveField(0)
  int? storyId;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? summary;
  @HiveField(3)
  String? modifiedAt;
  @HiveField(4)
  String? image;

  Story({this.storyId, this.title, this.summary, this.modifiedAt, this.image});

  Story.fromJson(Map<String, dynamic> json) {
    storyId = json['storyId'];
    title = json['title'];
    summary = json['summary'];
    modifiedAt = json['modifiedAt'];
    image = json['image'];
  }
}
