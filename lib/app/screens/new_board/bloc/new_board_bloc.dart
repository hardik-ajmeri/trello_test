import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trellotest/app/helpers/fs_helper.dart';
import 'package:trellotest/app/model/hl_board.dart';
import 'bloc.dart';
import 'package:trellotest/app/helpers/validators.dart';
import 'package:rxdart/rxdart.dart';

class NewBoardBloc extends Bloc<NewBoardEvent, NewBoardState> {
  @override
  NewBoardState get initialState => NewBoardState.empty();

  @override
  Stream<Transition<NewBoardEvent, NewBoardState>> transformEvents(
      Stream<NewBoardEvent> events,
      TransitionFunction<NewBoardEvent, NewBoardState> transitionFn) {
    final nonDebounceStream = events.where((event) {
      return (event is! NameChanged &&
          event is! TypeChanged &&
          event is! LableChanged &&
          event is! DescriptionChanged);
    });

    final debounceStream = events.where((e) {
      return (e is NameChanged || e is TypeChanged || e is LableChanged || e is DescriptionChanged);
    }).debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<NewBoardState> mapEventToState(NewBoardEvent event) async* {
    if (event is NameChanged) {
      yield* _mapNameChangedToState(event.title);
    } else if (event is TypeChanged) {
      yield* _mapTypeChangedToState(event.type);
    } else if (event is LableChanged) {
      yield* _mapLabelChangedToState(event.color_code);
    } else if (event is DescriptionChanged) {
      yield* _mapDescriptionChangedToState(event.desc);
    } else if (event is Submitted) {
      yield* _mapNewBoardAddedToState(event.title, event.type, event.code, event.desc);
    }
  }

  Stream<QuerySnapshot> getCategories() {
    return FSHelper().getCategories();
  }

  Stream<QuerySnapshot> getLables() {
    return FSHelper().getLables();
  }

  Stream<NewBoardState> _mapNameChangedToState(String title) async* {
    yield state.update(isValidName: Validators.isValidFullName(title));
  }

  Stream<NewBoardState> _mapLabelChangedToState(String hexCode) async* {
    yield state.update(isValidLable: Validators.isValidColorCode(hexCode));
  }

  Stream<NewBoardState> _mapTypeChangedToState(String type) async* {
    yield state.update(isValidType: Validators.isValidFullName(type));
  }

  Stream<NewBoardState> _mapDescriptionChangedToState(String desc) async* {
    yield state.update(isDescriptionValid: true);
  }

  Stream<NewBoardState> _mapNewBoardAddedToState(
      String title, String type, String hexCode, String desc) async* {
    yield NewBoardState.loading();
    try {
      var currentDate = Timestamp.fromDate(DateTime.now()).toString();
      var visitDate = Timestamp.fromDate(DateTime.now()).toString();
      HLBoard board = HLBoard(
          title: title,
          category: type,
          color_code: hexCode,
          description: desc,
          createdAt: currentDate,
          visitedAt: visitDate);
      DocumentReference ref = await FSHelper().addNewBoard(board);
      if (ref.documentID != null) {
        yield NewBoardState.success();
      } else {
        yield NewBoardState.failure();
      }
    } catch (_) {
      yield NewBoardState.failure();
    }
  }
}
