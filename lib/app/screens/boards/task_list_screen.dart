import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trellotest/app/model/hl_board.dart';
import 'package:trellotest/app/screens/boards/bloc/bloc.dart';
import 'package:trellotest/app/screens/boards/card_task_list_view.dart';
import 'package:trellotest/app/screens/boards/childs/reorderable_task_list_view.dart';
import 'package:trellotest/app/screens/boards/task_list_view.dart';

class TaskListScreen extends StatelessWidget {
  final HLBoard _board;

  TaskListScreen({Key key, @required HLBoard board})
      : assert(board != null),
        _board = board,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<TaskListBloc>(
        create: (context) => TaskListBloc(),
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus){
              currentFocus.unfocus();
            }
          },
          child: CardTaskListView(board: _board),
        )
      ),
    );
  }
}