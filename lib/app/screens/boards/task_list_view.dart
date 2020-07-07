import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trellotest/app/helpers/draggable_helper/drag_and_drop_list.dart';
import 'package:trellotest/app/model/hl_board.dart';
import 'package:trellotest/app/model/hl_card.dart';
import 'package:trellotest/app/model/hl_task.dart';
import 'package:trellotest/app/screens/boards/bloc/bloc.dart';
import 'package:trellotest/app/screens/boards/childs/board_list_header_view.dart';
import 'package:trellotest/app/screens/boards/childs/no_data_view.dart';

class TaskListView extends StatefulWidget {
  final HLBoard _board;

  TaskListView({Key key, HLBoard board})
      : assert(board != null),
        _board = board,
        super(key: key);

  @override
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  List<HLCard> cards = List<HLCard>();
  List<List<HLTask>> childres = List<List<HLTask>>();

  TaskListBloc _bloc;
  final focus = FocusNode();
  TextEditingController _cardTextController = TextEditingController();
  TextEditingController _taskTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<TaskListBloc>(context);
    _cardTextController.addListener(_onCardTitleChanged);
    _taskTextController.addListener(_onTaskTitleChanged);
  }

  @override
  void dispose() {
    _cardTextController.dispose();
    _taskTextController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _onCardTitleChanged() {
    _bloc.add(AddNewCardTitleChanged(title: _cardTextController.text));
  }

  void _onTaskTitleChanged() {
    _bloc.add(AddNewTaskTitleChanged(title: _taskTextController.text));
  }

  void _onNewCardSubmit() {
    _bloc.add(
        SubmittedCard(card: _cardTextController.text, board: widget._board));
    Navigator.of(context).pop(true);
  }

  void _onNewTaskSubmit(HLCard card) {
    _bloc.add(SubmittedTask(title: _taskTextController.text, card: card));
    Navigator.of(context).pop(true);
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
                    Text('Successful!!!'),
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
                    Text('Failed!!!'),
                    Icon(Icons.error),
                  ]),
              backgroundColor: Colors.red,
            ));
        }
      },
      child: BlocBuilder<TaskListBloc, TaskListState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BoardListHeaderView(
                  board: widget._board,
                  onPressed: () {
                    _showAddCard();
                  }),
              SizedBox(height: 8.0),
              StreamBuilder(
                stream: _bloc.getCards(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    cards.clear();
                    var cardDocs = snapshot.data.documents;
                    if (widget._board.cardIds != null) {
                      for (var i = 0; i < widget._board.cardIds.length; i++) {
                        for (var j = 0; j < cardDocs.length; j++) {
                          if (widget._board.cardIds[i] == cardDocs[j].documentID) {
                            cards.add(HLCard.fromJson(
                                jsonDecode(jsonEncode(cardDocs[j].data))));
                          }
                        }
                      }
                    }
                    if (cards.length == 0 || cards == null) {
                      return NoDataView();
                    } else {
                      return Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: cards.length,
                            itemBuilder: (context, index) {
                              return _buildCard(context, index, state);
                            },
                          ));
                    }
                  } else {
                    return Center(
                        child: SpinKitFadingCircle(
                            color: Theme.of(context).primaryColor));
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index, TaskListState state) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            width: 300.0,
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
            margin: const EdgeInsets.all(16.0),
            height: MediaQuery.of(context).size.height * 0.65,
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
                        cards[index].title,
                        style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.white, size: 32),
                        onPressed: () {
                          _showAddCardTask(index);
                          //showMyDialog(context, state);
                        },
                      )
                    ],
                  ),
                ),
                SingleChildScrollView(
                  reverse: true,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.56,
                    child: StreamBuilder(
                      stream: _bloc.getTasks(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data != null) {
                          childres.clear();
                          var taskDocs = snapshot.data.documents;
                          if(cards[index].taskIdList != null) {
                            for(var i = 0; i < cards[index].taskIdList.length; i++) {
                              List<HLTask> sublist = List<HLTask>();
                              for(var j = 0; j < taskDocs.length; j++) {
                                if(cards[index].taskIdList[i] == taskDocs[j].documentID) {
                                  HLTask task = HLTask.fromJson(jsonDecode(jsonEncode(taskDocs[j].data)));
                                  task.documentId = taskDocs[j].documentID;
                                  sublist.add(task);
                                }
                              }
                              childres[index] = []..addAll(sublist);
                            }
                          }
                          print("Hi: " + childres.toString());

                          if (childres[index].length == 0 || childres[index] == null) {
                            return NoDataView();
                          } else {
                            return DragAndDropList<HLTask>(
                              childres[index],
                              itemBuilder: (BuildContext context, item) {
                                return _buildCardTask(
                                    index, childres[index].indexOf(item));
                              },
                              onDragFinish: (oldIndex, newIndex) {
                                _handleReOrder(oldIndex, newIndex, index);
                              },
                              canBeDraggedTo: (one, two) => true,
                              dragElevation: 2.0,
                            );
                          }
                        } else {
                          return Center(
                              child: SpinKitFadingCircle(
                                  color: Theme.of(context).primaryColor));
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: DragTarget<dynamic>(
              onWillAccept: (data) {
                print(data);
                return true;
              },
              onLeave: (data) {},
              onAccept: (data) {
                if (data['from'] == index) {
                  return;
                }
                childres[data['from']].remove(data['string']);
                childres[index].add(data['string']);
                print(data);
                setState(() {});
              },
              builder: (context, accept, reject) {
                print("--- > $accept");
                print(reject);
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  _addCard(String text) {
    HLCard card = HLCard(title: text, taskIdList: []);
    cards.add(card);
    childres.add([]);
    _cardTextController.text = "";
    setState(() {});
  }

  _addCardTask(int index, String text) {
    HLTask task = HLTask(
        title: text, currentIndex: childres[index].length + 1, documentId: "");
    childres[index].add(task);
    _taskTextController.text = "";
    setState(() {});
  }

  _handleReOrder(int oldIndex, int newIndex, int index) {
    var oldValue = childres[index][oldIndex];
    childres[index][oldIndex] = childres[index][newIndex];
    childres[index][newIndex] = oldValue;
    setState(() {});
  }

  Container _buildCardTask(int index, int innerIndex) {
    return Container(
      width: 260.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Draggable<dynamic>(
        feedback: Material(
          elevation: 5.0,
          child: Container(
            width: 256.0,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12, width: 1)),
            child: Text(childres[index][innerIndex].title,
                style: TextStyle(fontSize: 19)),
          ),
        ),
        childWhenDragging: Opacity(
            opacity: 0.1,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12, width: 1)),
              child: Text(childres[index][innerIndex].title,
                  style: TextStyle(color: Colors.white, fontSize: 19)),
            )),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black12, width: 1)),
          child: Text(childres[index][innerIndex].title,
              style: TextStyle(fontSize: 19)),
        ),
        data: {"from": index, "string": childres[index][innerIndex]},
      ),
    );
  }

  _showAddCard() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
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
                    "Add New Card",
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
                        hintText: "Card Title",
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                      controller: _cardTextController,
//                      validator: (_) {
//                        return !state.isValidCardTitle
//                            ? 'Invalid Task title'
//                            : null;
//                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _addCard(_cardTextController.text.trim());
                      },
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

  _showAddCardTask(int index) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
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
                      controller: _taskTextController,
//                      validator: (_) {
//                        return !state.isValidCardTitle
//                            ? 'Invalid Task title'
//                            : null;
//                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _addCardTask(index, _taskTextController.text.trim());
                      },
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
}
