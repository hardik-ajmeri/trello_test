import 'package:flutter/material.dart';
import 'package:trellotest/app/screens/boards/task_list_view.dart';

class TaskListScreen extends StatelessWidget {
  final String _title;

  TaskListScreen({Key key, @required String title }) : assert(title != null),
        _title = title,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: TaskListView(),
    );
  }
}
