// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardList _$BoardListFromJson(Map<String, dynamic> json) {
  return BoardList(
    boards: (json['boards'] as List)
        ?.map((e) =>
            e == null ? null : HLBoard.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$BoardListToJson(BoardList instance) => <String, dynamic>{
      'boards': instance.boards,
    };
