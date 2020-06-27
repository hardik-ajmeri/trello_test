import 'package:flutter/material.dart';
import 'package:trellotest/app/model/hl_board.dart';
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
      body: TaskListView(board: _board),
    );
  }
}
