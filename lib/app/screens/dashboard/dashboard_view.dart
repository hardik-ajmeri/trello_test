import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trellotest/app/helpers/hex_color.dart';
import 'package:trellotest/app/model/hl_board.dart';
import 'package:trellotest/app/navigation/routes.dart';
import 'package:trellotest/app/screens/dashboard/bloc/bloc.dart';
import 'package:trellotest/app/screens/dashboard/childs/user_view.dart';

class DashboardView extends StatefulWidget {
  DashboardView({Key key}) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  DashboardBloc _bloc;
  List<HLBoard> recentBoards = List<HLBoard>();
  List<HLBoard> personalBoards = List<HLBoard>();
  List<HLBoard> workBoards = List<HLBoard>();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<DashboardBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardBloc, DashboardState>(
      listener: (context, state) {},
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return Container(
            color: Colors.black.withAlpha(15),
            child: Column(
              children: <Widget>[
                UserView(),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 40),
//                        Padding(
//                            padding: EdgeInsets.symmetric(horizontal: 24),
//                            child: Row(
//                              children: <Widget>[
//                                Icon(Icons.history, size: 32),
//                                SizedBox(width: 8),
//                                Text('Recents',
//                                    style: TextStyle(
//                                        fontSize: 17, fontWeight: FontWeight.bold))
//                              ],
//                            )),
//                        SizedBox(height: 40),
//                        StreamBuilder(
//                          stream: _bloc.getPersonalBoards(),
//                          builder: (BuildContext context,
//                              AsyncSnapshot<QuerySnapshot> snapshot) {
//                            personalBoards.clear();
//                            if (snapshot.data != null) {
//                              snapshot.data.documents.forEach((element) {
//                                if(element.data != null) {
//                                  personalBoards.add(HLBoard.fromJson(jsonDecode(jsonEncode(element.data))));
//                                }
//                              });
//
//                              if(personalBoards != null) {
//                                return BoardCard(context, personalBoards);
//                              } else {
//                                return Text('No boards to show.');
//                              }
//                            } else {
//                              return Text('No boards to show.');
//                            }
//                          },
//                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.account_circle,
                                    size: 32,
                                    color: Theme.of(context).primaryColor),
                                SizedBox(width: 8),
                                Text('Personal',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold))
                              ],
                            )),
                        //SizedBox(height: 40),
                        StreamBuilder(
                          stream: _bloc.getPersonalBoards(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            personalBoards.clear();
                            if (snapshot.data != null) {
                              snapshot.data.documents.forEach((element) {
                                if (element.data != null) {
                                  personalBoards.add(HLBoard.fromJson(
                                      jsonDecode(jsonEncode(element.data))));
                                }
                              });
                              if (personalBoards != null) {
                                return BoardCard(context, personalBoards, true);
                              } else {
                                return Text('No boards to show.');
                              }
                            } else {
                              return Text('No boards to show.');
                            }
                          },
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.work,
                                    size: 32,
                                    color: Theme.of(context).primaryColor),
                                SizedBox(width: 8),
                                Text('Work',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold))
                              ],
                            )),
                        StreamBuilder(
                          stream: _bloc.getWoklBoards(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            workBoards.clear();
                            if (snapshot.data != null) {
                              snapshot.data.documents.forEach((element) {
                                if (element.data != null) {
                                  workBoards.add(HLBoard.fromJson(
                                      jsonDecode(jsonEncode(element.data))));
                                }
                              });

                              if (workBoards != null) {
                                return BoardCard(context, workBoards, false);
                              } else {
                                return Text('No boards to show.');
                              }
                            } else {
                              return Text('No boards to show.');
                            }
                          },
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget BoardCard(BuildContext context, List<HLBoard> list, bool isPersonal) {
    return Container(
      height: 200,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ViewBoardRoute,
                      arguments: list[index]);
                },
                child: Container(
                  height: 200,
                  width: 250,
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black12, width: 2),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 15.0,
                            spreadRadius: 5.0,
                            color: Colors.black.withAlpha(15))
                      ],
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        list[index].color_code != null
                            ? Container(
                                width: 100,
                                height: 8,
                                decoration: BoxDecoration(
                                    color: HexColor(list[index].color_code),
                                    shape: BoxShape.rectangle),
                              )
                            : Container(height: 0),
                        SizedBox(height: 8),
                        Text(list[index].title,
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(list[index].description,
                            style: TextStyle(fontSize: 15))
                      ],
                    ),
                  ),
                ));
          }),
    );
  }
}
