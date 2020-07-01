import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trellotest/app/model/hl_board.dart';
import 'package:trellotest/app/model/hl_card.dart';
import 'package:trellotest/app/screens/boards/bloc/bloc.dart';
import 'package:trellotest/app/screens/boards/childs/board_list_header_view.dart';
import 'package:trellotest/app/screens/boards/childs/reorderable_task_list_view.dart';

class CardTaskListView extends StatefulWidget {
  final HLBoard _board;

  CardTaskListView({Key key, HLBoard board})
      : assert(board != null),
        _board = board,
        super(key: key);

  @override
  _CardTaskListViewState createState() => _CardTaskListViewState();
}

class _CardTaskListViewState extends State<CardTaskListView> {
  TaskListBloc _bloc;
  List<HLCard> cards = List<HLCard>();
  final focus = FocusNode();
  TextEditingController _cardTitleController = TextEditingController();
  TextEditingController _taskTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<TaskListBloc>(context);
    _cardTitleController.addListener(_onCardTitleChanged);
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
          _cardTitleController.text = "";
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
          return Column(
            children: <Widget>[
              BoardListHeaderView(board: widget._board, onPressed: () {
                showMyDialog(context, state);
              }),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: StreamBuilder(
                  stream: _bloc.getCards(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      cards.clear();
                      var cardDocs = snapshot.data.documents;
                      for (var i = 0; i < widget._board.cardIds.length; i++) {
                        for (var j = 0; j < cardDocs.length; j++) {
                          if (widget._board.cardIds[i] ==
                              cardDocs[j].documentID) {
                            cards.add(HLCard.fromJson(
                                jsonDecode(jsonEncode(cardDocs[j].data))));
                          }
                        }
                      }
                      return _buildReordarableListView(context, cards, state);
                    } else {
                      return Center(
                          child: SpinKitFadingCircle(
                              color: Theme.of(context).primaryColor));
                    }
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildReordarableListView(
      BuildContext context, List<HLCard> cards, TaskListState state) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: cards.length,
      itemBuilder: (context, index) {
          return ReorderableTaskListView(card: cards[index]);
      },
    );
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
                      controller: _cardTitleController,
                      validator: (_) {
                        return !state.isValidCardTitle
                            ? 'Invalid Card title'
                            : null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: RaisedButton(
                      onPressed: _onNewCardSubmit,
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

  @override
  void dispose() {
    _cardTitleController.dispose();
    super.dispose();
  }

  void _onCardTitleChanged() {
    _bloc.add(AddNewCardTitleChanged(title: _cardTitleController.text));
  }

  void _onNewCardSubmit() {
    _bloc.add(SubmittedCard(card: _cardTitleController.text, board: widget._board));
    Navigator.of(context).pop(true);
  }
}
