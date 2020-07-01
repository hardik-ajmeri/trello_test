import 'package:json_annotation/json_annotation.dart';
part 'board_category.g.dart';

@JsonSerializable()
class BoardCategory {
  final List<String> categories;
  BoardCategory({this.categories});

  factory BoardCategory.fromJson(Map<String, dynamic> json) => _$BoardCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$BoardCategoryToJson(this);
}