import 'package:json_annotation/json_annotation.dart';
part 'hl_lables.g.dart';

@JsonSerializable()
class HLLables {
  final String color_code;
  final List<String> tags;

  HLLables({this.color_code, this.tags});

  factory HLLables.fromJson(Map<String, dynamic> json) => _$HLLablesFromJson(json);
  Map<String, dynamic> toJson() => _$HLLablesToJson(this);
}