import 'package:json_annotation/json_annotation.dart';
part 'hl_task.g.dart';

@JsonSerializable()
class HLTask {
  final String title;
  final int currentIndex;

  HLTask({this.title, this.currentIndex});

  factory HLTask.fromJson(Map<String, dynamic> json) => _$HLTaskFromJson(json);
  Map<String, dynamic> toJson() => _$HLTaskToJson(this);
}