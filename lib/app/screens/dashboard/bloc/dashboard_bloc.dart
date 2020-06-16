import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trellotest/app/helpers/fs_helper.dart';
import 'package:trellotest/app/model/hl_board.dart';

import 'bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  @override
  DashboardState get initialState => DashboardState.empty();

  @override
  Stream<Transition<DashboardEvent, DashboardState>> transformEvents(
      Stream<DashboardEvent> events,
      TransitionFunction<DashboardEvent, DashboardState> transitionFn) {
    final nonDebounceStream = events.where((event) {
      return (event is! SearchQueryChanged);
    });

    final debounceStream = events.where((e) {
      return (e is SearchQueryChanged);
    }).debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if(event is SearchQueryChanged){
      yield* _mapSearchChangedToState(event.query);
    } else if(event is Submitted) {
      yield* _mapFormSubmittedToState(event.query);
    }
  }

  Stream<QuerySnapshot> getPersonalBoards() {
    return FSHelper().getPersonalBoards();
  }

  Stream<QuerySnapshot> getWoklBoards() {
    return FSHelper().getWorkBoards();
  }

  Stream<DashboardState> _mapSearchChangedToState(String query) async* {
    yield state.update(isValidSearchInput: true);
  }

  Stream<DashboardState> _mapFormSubmittedToState(String query) async* {
    yield DashboardState.loading();
    try {
      yield DashboardState.success();
    } catch (_) {
      yield DashboardState.failure();
    }
  }
}
