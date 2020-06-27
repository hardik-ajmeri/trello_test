import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class NewBoardEvent extends Equatable {
  const NewBoardEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends NewBoardEvent {
  final String title;
  const NameChanged({@required this.title});

  @override
  List<Object> get props => [title];

  @override
  String toString() => 'NameChanged { title: $title }';
}

class TypeChanged extends NewBoardEvent {
  final String type;
  const TypeChanged({@required this.type});

  @override
  List<Object> get props => [type];

  @override
  String toString() => 'TypeChanged { type: $type }';
}

class LableChanged extends NewBoardEvent {
  final String color_code;
  const LableChanged({@required this.color_code});

  @override
  List<Object> get props => [LableChanged];

  @override
  String toString() => 'LableChanged { type: $color_code }';
}

class DescriptionChanged extends NewBoardEvent {
  final String desc;
  const DescriptionChanged({@required this.desc});

  @override
  List<Object> get props => [desc];

  @override
  String toString() => 'DescriptionChanged { type: $desc }';
}

class Submitted extends NewBoardEvent {
  final String title;
  final String type;
  final String code;
  final String desc;

  const Submitted(
      {@required this.title,
      @required this.type, @required this.code, @required this.desc});

  @override
  List<Object> get props => [title, type, code, desc];

  @override
  String toString() {
    return 'Submitted { title: $title, type: $type, code: $code, description: $desc }';
  }
}
