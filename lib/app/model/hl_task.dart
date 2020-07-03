import 'package:json_annotation/json_annotation.dart';
part 'hl_task.g.dart';

@JsonSerializable()
class HLTask {
  final String title;
  final int currentIndex;
  String documentId;

  HLTask({this.title, this.currentIndex, this.documentId});

  factory HLTask.fromJson(Map<String, dynamic> json) => _$HLTaskFromJson(json);
  Map<String, dynamic> toJson() => _$HLTaskToJson(this);
}