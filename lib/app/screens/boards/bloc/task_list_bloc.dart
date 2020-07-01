import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trellotest/app/helpers/fs_helper.dart';
import 'package:trellotest/app/model/hl_board.dart';
import 'package:trellotest/app/model/hl_card.dart';
import 'package:trellotest/app/model/hl_task.dart';

import 'bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  @override
  TaskListState get initialState => TaskListState.empty();

  @override
  Stream<Transition<TaskListEvent, TaskListState>> transformEvents(
      Stream<TaskListEvent> events,
      TransitionFunction<TaskListEvent, TaskListState> transitionFn) {
    final nonDebounceStream = events.where((event) {
      return (event is! AddNewCardTitleChanged &&
          event is! AddNewCardTitleChanged &&
          event is! TaskMovedToOtherCard &&
          event is! TaskMovedToSameCard &&
          event is! SubmittedTask &&
          event is! SubmittedCard);
    });

    final debounceStream = events.where((e) {
      return (e is AddNewCardTitleChanged ||
          e is AddNewCardTitleChanged ||
          e is TaskMovedToOtherCard ||
          e is TaskMovedToSameCard ||
          e is SubmittedTask ||
          e is SubmittedCard);
    }).debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<TaskListState> mapEventToState(TaskListEvent event) async* {
    if (event is AddNewCardTitleChanged) {
      yield* _mapCardTitleToState(event.title);
    } else if (event is AddNewTaskTitleChanged) {
      yield* _mapTaskTitleToState(event.title);
    } else if (event is TaskMovedToSameCard) {
      yield* _mapTaskMovedtoSameCardState(event.task, event.oldIndex, event.newIndex);
    } else if (event is TaskMovedToOtherCard) {
      yield* _mapTaskMovedtoOtherCardState(event.oldCardId, event.newCardId, event.taskIndex);
    } else if (event is SubmittedTask) {
      yield* _mapTaskSubmittedToState(event.title, event.index);
    } else if (event is SubmittedCard) {
      yield* _mapCardSubmittedToState(event.card, event.board);
    }
  }

  Stream<QuerySnapshot> getCards() {
    return FSHelper().getCards();
  }

  Stream<QuerySnapshot> getTasks() {
    return FSHelper().getTasks();
  }

  Stream<TaskListState> _mapTaskMovedtoOtherCardState(String oldCardId, String newCardId, int index) async* {
    yield TaskListState.loading();
    try {
      yield TaskListState.success();
    } catch(_) {
      yield TaskListState.failure();
    }
  }

  Stream<TaskListState> _mapTaskMovedtoSameCardState(HLTask task, int oldIndex, int newIndex) async* {
    yield TaskListState.loading();
    try {
      yield TaskListState.success();
    } catch(_) {
      yield TaskListState.failure();
    }
  }

  Stream<TaskListState> _mapTaskTitleToState(String title) async* {
    yield state.update(isValidTaskTitle: true);
  }

  Stream<TaskListState> _mapCardTitleToState(String title) async* {
    yield state.update(isValidCardTitle: true);
  }

  Stream<TaskListState> _mapTaskSubmittedToState(
      String title, int index) async* {
    yield TaskListState.loading();
    try {
      HLTask task = HLTask(title: title, currentIndex: index);
      DocumentReference ref = await FSHelper().addNewTask(task);
      if (ref.documentID != null) {
        yield TaskListState.success();
      } else {
        yield TaskListState.failure();
      }
    } catch (_) {
      TaskListState.failure();
    }
  }

  Stream<TaskListState> _mapCardSubmittedToState(String title, HLBoard board) async* {
    yield TaskListState.loading();
    try {
      HLCard card = HLCard(title: title);
      HLBoard newBoard = board;
      DocumentReference ref = await FSHelper().addNewCard(card);
      if (ref.documentID != null) {
        newBoard.cardIds.add(ref.documentID);
        await FSHelper().updateBoard(newBoard);
        yield TaskListState.success();
      } else {
        yield TaskListState.failure();
      }
    } catch (_) {
      TaskListState.failure();
    }
  }
}
