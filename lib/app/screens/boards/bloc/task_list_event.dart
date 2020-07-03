import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:trellotest/app/model/hl_board.dart';
import 'package:trellotest/app/model/hl_card.dart';
import 'package:trellotest/app/model/hl_task.dart';

abstract class TaskListEvent extends Equatable {
  const TaskListEvent();

  @override
  List<Object> get props => [];
}

class AddNewTaskTitleChanged extends TaskListEvent {
  final String title;
  const AddNewTaskTitleChanged({@required this.title});

  @override
  List<Object> get props => [title];

  @override
  String toString() => 'AddNewTaskTitleChanged { task title: $title }';
}

class AddNewCardTitleChanged extends TaskListEvent {
  final String title;
  const AddNewCardTitleChanged({@required this.title});

  @override
  List<Object> get props => [title];

  @override
  String toString() => 'AddNewCardTitleChanged { card title: $title }';
}

class TaskMovedToOtherCard extends TaskListEvent {
  final String oldCardId;
  final String newCardId;
  final int taskIndex;

  const TaskMovedToOtherCard(
      {@required this.oldCardId,
      @required this.newCardId,
      @required this.taskIndex});

  @override
  List<Object> get props => [oldCardId, newCardId, taskIndex];

  @override
  String toString() =>
      'TaskMovedToOtherCard { oldCard: $oldCardId, newCard: $newCardId, newIndex: $taskIndex }';
}

class Fetch extends TaskListEvent {
  @override
  String toString() => 'Loading Cards';
}

class TaskMovedToSameCard extends TaskListEvent {
  final HLTask task;
  final int oldIndex;
  final int newIndex;
  const TaskMovedToSameCard({@required this.task, @required this.oldIndex, @required this.newIndex});

  @override
  List<Object> get props => [task, oldIndex, newIndex];

  @override
  String toString() =>
      'TaskMovedToSameCard { current task: $task, old index: $oldIndex, new index: $newIndex }';
}

class SubmittedTask extends TaskListEvent {
  final String title;
  final HLCard card;
  const SubmittedTask({@required this.title, @required this.card});

  @override
  List<Object> get props => [title, card];

  @override
  String toString() => 'SubmittedTask { title: $title, card: $card }';
}

class SubmittedCard extends TaskListEvent {
  final String card;
  final HLBoard board;
  const SubmittedCard({@required this.card, @required this.board});

  @override
  List<Object> get props => [card, board];

  @override
  String toString() => 'SubmittedCard { title: $card }';
}
