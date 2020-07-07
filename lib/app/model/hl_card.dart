import 'package:json_annotation/json_annotation.dart';
part 'hl_card.g.dart';

@JsonSerializable()
class HLCard {
  final String title;
  List<String> taskIdList;
  String documentId;

  HLCard({this.title, this.taskIdList, this.documentId});

  factory HLCard.fromJson(Map<String, dynamic> json) => _$HLCardFromJson(json);
  Map<String, dynamic> toJson() => _$HLCardToJson(this);
}