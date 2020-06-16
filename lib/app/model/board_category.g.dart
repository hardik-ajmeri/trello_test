// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardCategory _$BoardCategoryFromJson(Map<String, dynamic> json) {
  return BoardCategory(
    categories: (json['categories'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$BoardCategoryToJson(BoardCategory instance) =>
    <String, dynamic>{
      'categories': instance.categories,
    };
