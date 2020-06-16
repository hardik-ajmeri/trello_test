import 'package:json_annotation/json_annotation.dart';
part 'hl_board.g.dart';
@JsonSerializable()
class HLBoard {
  final String title;
  final String category;
  final String description;
  final String createdAt;
  final String visitedAt;

  HLBoard({
    this.title,
    this.category,
    this.description,
    this.createdAt,
    this.visitedAt,
  });

  factory HLBoard.fromJson(Map<String, dynamic> json) => _$HLBoardFromJson(json);
  Map<String, dynamic> toJson() => _$HLBoardToJson(this);
}