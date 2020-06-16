import 'package:json_annotation/json_annotation.dart';
import 'package:trellotest/app/model/hl_board.dart';
part 'board_list.g.dart';

@JsonSerializable()
class BoardList {
  List<HLBoard> boards;
  BoardList({this.boards});

  factory BoardList.fromJson(Map<String, dynamic> json) => _$BoardListFromJson(json);
  Map<String, dynamic> toJson() => _$BoardListToJson(this);

}