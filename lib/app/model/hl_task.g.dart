// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hl_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HLTask _$HLTaskFromJson(Map<String, dynamic> json) {
  return HLTask(
    title: json['title'] as String,
    currentIndex: json['currentIndex'] as int,
  );
}

Map<String, dynamic> _$HLTaskToJson(HLTask instance) => <String, dynamic>{
      'title': instance.title,
      'currentIndex': instance.currentIndex,
    };
