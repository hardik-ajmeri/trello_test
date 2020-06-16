// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hl_board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HLBoard _$HLBoardFromJson(Map<String, dynamic> json) {
  return HLBoard(
    title: json['title'] as String,
    category: json['category'] as String,
    description: json['description'] as String,
    createdAt: json['createdAt'] as String,
    visitedAt: json['visitedAt'] as String,
  );
}

Map<String, dynamic> _$HLBoardToJson(HLBoard instance) => <String, dynamic>{
      'title': instance.title,
      'category': instance.category,
      'description': instance.description,
      'createdAt': instance.createdAt,
      'visitedAt': instance.visitedAt,
    };
