import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trellotest/app/model/hl_card.dart';
import 'package:trellotest/app/model/hl_task.dart';
import 'package:trellotest/app/screens/boards/bloc/bloc.dart';
import 'package:trellotest/app/screens/boards/childs/no_data_view.dart';

class ReorderableTaskListView extends StatefulWidget {
  final HLCard _card;

  ReorderableTaskListView({Key key, @required HLCard card})
      : assert(card != null),
        _card = card,
        super(key: key);

  @override
  _ReorderableTaskListViewState createState() =>
      _ReorderableTaskListViewState();
}

class _ReorderableTaskListViewState extends State<ReorderableTaskListView> {
  TaskListBloc _bloc;
  List<HLTask> tasks = List<HLTask>();
  ScrollController scrollController = ScrollController();
  TextEditingController _taskTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<TaskListBloc>(context);
    _taskTitleController.addListener(_onTaskTitleChanged);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskListBloc, TaskListState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Submitting...'),
                  SpinKitFadingCircle(color: Theme.of(context).primaryColor),
                ],
              ),
            ));
        }

        if (state.isSuccess) {
          _taskTitleController.text = "";
          //tasks.sort((o, n) => o.currentIndex.compareTo(n.currentIndex));
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Task added successfully'),
                    Icon(Icons.check_circle),
                  ]),
              backgroundColor: Colors.green,
            ));
        }

        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Failed to add new task'),
                    Icon(Icons.error),
                  ]),
              backgroundColor: Colors.red,
            ));
        }
      },
      child: BlocBuilder<TaskListBloc, TaskListState>(
        builder: (context, state) {
          return Container(
            margin: const EdgeInsets.all(16.0),
            //padding: const EdgeInsets.all(16.0),
            width: 300,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 8,
                    offset: Offset(0, 0),
                    color: Color.fromRGBO(127, 140, 141, 0.5),
                    spreadRadius: 1)
              ],
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Theme.of(context).primaryColor),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget._card.title,
                        style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.white, size: 32),
                        onPressed: () {
                          showMyDialog(context, state);
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                StreamBuilder(
                  stream: _bloc.getTasks(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      tasks.clear();
                      var taskDocs = snapshot.data.documents;
                      if (widget._card.taskIdList != null) {
                        for (var i = 0;
                            i < widget._card.taskIdList.length;
                            i++) {
                          for (var j = 0; j < taskDocs.length; j++) {
                            if (widget._card.taskIdList[i] ==
                                taskDocs[j].documentID) {
                              HLTask task = HLTask.fromJson(
                                  jsonDecode(jsonEncode(taskDocs[j].data)));
                              task.documentId = taskDocs[i].documentID;
                              tasks.add(task);
                            }
                          }
                        }
                      }

                      if (tasks.length == 0 || tasks == null) {
                        return NoDataView();
                      } else {
                        return _buildTaskList(context, tasks);
                      }
                    } else {
                      return Center(
                          child: SpinKitFadingCircle(
                              color: Theme.of(context).primaryColor));
                    }
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, List<HLTask> tasks) {
    return Flexible(
      child: ReorderableListView(
        scrollController: scrollController,
        onReorder: _onReorder,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: List.generate(tasks.length, (index) {
          return TaskListCard(
            tasks: tasks,
            index: index,
            key: Key('$index'),
          );
        }),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      //dragging from top to bottom
      int end = newIndex - 1;
      HLTask startTask = tasks[oldIndex];
      int i = 0;
      int local = oldIndex;
      do {
        tasks[local] = tasks[++local];
        i++;
      } while (i < end - oldIndex);
      tasks[end] = startTask;
      _onTaskMovedtoSameList(startTask, oldIndex, newIndex);
    } else if (oldIndex > newIndex) {
      //dragging from bottom to top
      HLTask startTask = tasks[oldIndex];
      for (int i = oldIndex; i > newIndex; i--) {
        tasks[i] = tasks[i - 1];
      }
      tasks[newIndex] = startTask;
      _onTaskMovedtoSameList(startTask, oldIndex, newIndex);
    }
    setState(() {});
  }

  showMyDialog(BuildContext context, TaskListState state) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            insetPadding: EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Add New Task",
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                  child: Container(
                    height: 44,
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(25),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        hintText: "Task Title",
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                      controller: _taskTitleController,
                      validator: (_) {
                        return !state.isValidCardTitle
                            ? 'Invalid Task title'
                            : null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: RaisedButton(
                      onPressed: _onNewTaskSubmit,
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(Icons.add, color: Colors.white, size: 24),
                            Text("Add",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white))
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void _onTaskMovedtoSameList(HLTask task, int o, int n) {
    _bloc.add(TaskMovedToSameCard(task: task, oldIndex: o, newIndex: n));
  }

  void _onTaskTitleChanged() {
    _bloc.add(AddNewTaskTitleChanged(title: _taskTitleController.text));
  }

  void _onNewTaskSubmit() {
    _bloc.add(
        SubmittedTask(title: _taskTitleController.text, card: widget._card));
    Navigator.of(context).pop(true);
  }
}

class TaskListCard extends StatefulWidget {
  final int index;
  final Key key;
  final List<HLTask> tasks;

  TaskListCard({this.index, this.key, this.tasks});

  @override
  State<StatefulWidget> createState() => _TaskListCardState();
}

class _TaskListCardState extends State<TaskListCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black38, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 240,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.all(8.0),
        child: Text(widget.tasks[widget.index].title,
            style: TextStyle(fontSize: 19)),
      ),
    );
//    return Draggable(
//      feedback: super.widget,
//      child: taskCard(context),
//      childWhenDragging: taskWhileDraggingCard(context),
//      data: widget.tasks[widget.index],
//    );
  }

  Widget taskCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black38, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 240,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.all(8.0),
        child: Text(widget.tasks[widget.index].title,
            style: TextStyle(fontSize: 19)),
      ),
    );
  }

  Widget taskWhileDraggingCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black38, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 240,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.all(8.0),
        child: Text(widget.tasks[widget.index].title,
            style: TextStyle(fontSize: 19, color: Colors.white)),
      ),
    );
  }
}
