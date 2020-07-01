import 'package:flutter/material.dart';
import 'package:trellotest/app/helpers/hex_color.dart';
import 'package:trellotest/app/model/hl_board.dart';

class BoardListHeaderView extends StatelessWidget {
  final HLBoard _board;
  final VoidCallback _onPressed;

  BoardListHeaderView({Key key, @required HLBoard board, @required VoidCallback onPressed})
      : assert(board != null),
        _board = board,
        _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 15.0, spreadRadius: 15.0)
        ],
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.275,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 44.0),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.chevron_left, size: 32),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(_board.category,
                      style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                      textAlign: TextAlign.center),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: FlatButton(
                      padding: const EdgeInsets.all(8.0),
                      onPressed: _onPressed,
                      child: Text("Add Card", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert, size: 32),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 16.0),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: _board.color_code != null ? HexColor(_board.color_code) : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(_board.tag != null ? _board.tag : "Planing",
                        style: TextStyle(
                            color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                  Text("4 Members in this board",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))
                ],
              )),
          SizedBox(height: 8.0),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(_board.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left)),
          SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 44,
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  hintText: "Search tasks here",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey,),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
