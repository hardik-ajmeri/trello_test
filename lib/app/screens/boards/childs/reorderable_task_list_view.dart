import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trellotest/app/model/hl_card.dart';
import 'package:trellotest/app/model/hl_task.dart';
import 'package:trellotest/app/screens/boards/bloc/bloc.dart';

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
  ScrollController scrollController =  ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<TaskListBloc>(context);
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
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Card added successfully'),
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
                    Text('Failed to add new card'),
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
                      for (var i = 0; i < widget._card.taskIdList.length; i++) {
                        for (var j = 0; j < taskDocs.length; j++) {
                          tasks.add(HLTask.fromJson(
                              jsonDecode(jsonEncode(taskDocs[j].data))));
                        }
                      }
                      //tasks.sort((a, b) => a.currentIndex.compareTo(b.currentIndex));
                      return _buildTaskList(context, tasks);
                    } else {
                      return Center(child: Text("No Data"));
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
    return Flexible(child: ReorderableListView(
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
    ));
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex = -1;
      }
      final HLTask task = tasks.removeAt(oldIndex);
      tasks.insert(newIndex, task);
    });
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
        child: Text(widget.tasks[widget.index].title, style: TextStyle(fontSize: 19)),
      ),
    );
  }

}