import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'task_list_event.dart';

part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  @override
  TaskListState get initialState => InitialTaskListState();

  @override
  Stream<TaskListState> mapEventToState(TaskListEvent event) async* {
    // TODO: Add your event logic
  }
}
