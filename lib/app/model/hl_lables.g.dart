// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hl_lables.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HLLables _$HLLablesFromJson(Map<String, dynamic> json) {
  return HLLables(
    color_code: json['color_code'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$HLLablesToJson(HLLables instance) => <String, dynamic>{
      'color_code': instance.color_code,
      'tags': instance.tags,
    };
