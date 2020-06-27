// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hl_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HLCard _$HLCardFromJson(Map<String, dynamic> json) {
  return HLCard(
    title: json['title'] as String,
    taskIdList: (json['taskIdList'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$HLCardToJson(HLCard instance) => <String, dynamic>{
      'title': instance.title,
      'taskIdList': instance.taskIdList,
    };
