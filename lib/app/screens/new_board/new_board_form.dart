import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trellotest/app/helpers/hex_color.dart';
import 'package:trellotest/app/model/board_category.dart';
import 'package:trellotest/app/model/hl_lables.dart';
import 'package:trellotest/app/navigation/routes.dart';
import 'package:trellotest/app/screens/new_board/bloc/bloc.dart';

class NewBoardForm extends StatefulWidget {
  NewBoardForm({Key key}) : super(key: key);

  @override
  _NewBoardFormState createState() => _NewBoardFormState();
}

class _NewBoardFormState extends State<NewBoardForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  NewBoardBloc _bloc;
  int _selectedCategoryIndex, _selectedLableIndex;
  BoardCategory cats;
  List<HLLables> lablesList = List<HLLables>();
  final focus = FocusNode();

  bool get isPopulated =>
      _nameController.text.isNotEmpty && _descriptionController.text.isNotEmpty;

  bool isRegisterButtonEnabled(NewBoardState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<NewBoardBloc>(context);
    _nameController.addListener(_onTitleChanged);
    _descriptionController.addListener(_onDescriptionChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NewBoardBloc, NewBoardState>(
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
          _nameController.text = "";
          _descriptionController.text = "";
          _selectedCategoryIndex = null;
          _selectedLableIndex = null;

          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Board added successfully'),
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
                    Text('Failed to add new board'),
                    Icon(Icons.error),
                  ]),
              backgroundColor: Colors.red,
            ));
        }
      },
      child: BlocBuilder<NewBoardBloc, NewBoardState>(
        builder: (context, state) {
          return Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(height: 64),
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 15.0,
                                      spreadRadius: 5.0,
                                      color: Colors.black12)
                                ],
                                border: Border.all(
                                    color: Colors.white12, width: 1)),
                            child: Padding(
                                padding: EdgeInsets.all(24),
                                child: Icon(
                                  Icons.playlist_add,
                                  color: Colors.white,
                                  size: 40,
                                )),
                          ),
                          SizedBox(height: 24.0),
                          Text(
                            'Add New Board',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 40.0),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            padding: EdgeInsets.symmetric(
                                vertical: 24, horizontal: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text('Board Title',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 19,
                                        color: Colors.black87)),
                                SizedBox(height: 8.0),
                                TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Board Title',
                                      focusColor:
                                          Theme.of(context).primaryColor,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1)),
                                    ),
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    autovalidate: false,
                                    autocorrect: false,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus);
                                    },
                                    validator: (_) {
                                      return !state.isValidName
                                          ? 'Invalid Board Title'
                                          : null;
                                    }),
                                SizedBox(height: 24.0),
                                Text('Category',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 19,
                                        color: Colors.black87)),
                                SizedBox(height: 8.0),
                                StreamBuilder(
                                  stream: _bloc.getCategories(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      cats = BoardCategory.fromJson(jsonDecode(
                                          jsonEncode(snapshot
                                              .data.documents.first.data)));
                                      if (cats.categories.isNotEmpty) {
                                        return buildCategoryList(
                                            cats.categories, context);
                                      } else {
                                        return Text('Personal');
                                      }
                                    } else {
                                      return Text('Personal');
                                    }
                                  },
                                ),
                                SizedBox(height: 24.0),
                                Text('Labels',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 19,
                                        color: Colors.black87)),
                                SizedBox(height: 8.0),
                                StreamBuilder(
                                  stream: _bloc.getLables(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    lablesList.clear();
                                    if (snapshot.hasData) {
                                      snapshot.data.documents.forEach((element) {
                                        lablesList.add(HLLables.fromJson(jsonDecode(jsonEncode(element.data))));
                                      });

                                      if(lablesList.length > 0) {
                                        return buildLablesList(context, lablesList);
                                      } else  {
                                        return Container();
                                      }
                                    } else  {
                                      return Container();
                                    }
                                  },
                                ),
                                SizedBox(height: 24.0),
                                Text('Description',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 19,
                                        color: Colors.black87)),
                                SizedBox(height: 8.0),
                                TextFormField(
                                    controller: _descriptionController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter short Description',
                                      focusColor:
                                          Theme.of(context).primaryColor,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1)),
                                    ),
                                    cursorColor: Theme.of(context).primaryColor,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 3,
                                    textInputAction: TextInputAction.done,
                                    autovalidate: false,
                                    autocorrect: false,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus);
                                    },
                                    validator: (_) {
                                      return !state.isDescriptionValid
                                          ? 'Invalid Description'
                                          : null;
                                    }),
                                SizedBox(height: 24.0),
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  onPressed: _onFormSubmitted,
                                  color: Theme.of(context).primaryColor,
                                  child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Add Board",
                                            style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          )
                                        ],
                                      )),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCategoryList(List<String> categories, BuildContext context) {
    _onSelected(int index) {
      setState(() {
        _selectedCategoryIndex = index;
        _onTypeChanged();
      });
    }

    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).primaryColor, width: 1),
          ),
          child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(categories[index],
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                              _selectedCategoryIndex != null && _selectedCategoryIndex == index
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                          color:
                          _selectedCategoryIndex != null && _selectedCategoryIndex == index
                                  ? Theme.of(context).primaryColor
                                  : Colors.black)),
                  onTap: () => _onSelected(index),
                  trailing: _selectedCategoryIndex != null && _selectedCategoryIndex == index
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: Icon(
                            Icons.check,
                            size: 24,
                            color: _selectedCategoryIndex != null &&
                                _selectedCategoryIndex == index
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ))
                      : null,
                );
              },
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemCount: categories.length),
        ));
  }

  Widget buildLablesList(BuildContext context, List<HLLables> lables) {
    _onSelected(int index) {
      setState(() {
        _selectedLableIndex = index;
        _onLabelChanged();
      });
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 32,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _onSelected(index),
            child: Container(
              height: 32,
              width: 32,
              margin: EdgeInsets.symmetric(horizontal: (MediaQuery.of(context).size.width/lables.length)*0.175),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: _selectedLableIndex == index ? Theme.of(context).primaryColor : Colors.transparent,
                      width: _selectedLableIndex == index ? 2 : 0
                  )
              ),
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: HexColor(lables[index].color_code != null ? lables[index].color_code : Colors.black),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        },
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: lables.length,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onTitleChanged() {
    _bloc.add(NameChanged(title: _nameController.text));
  }

  void _onDescriptionChanged() {
    _bloc.add(DescriptionChanged(desc: _descriptionController.text));
  }

  void _onTypeChanged() {
    if (cats.categories.length > 0 && _selectedCategoryIndex != null) {
      _bloc.add(TypeChanged(type: cats.categories[_selectedCategoryIndex]));
    } else {
      _bloc.add(TypeChanged(type: cats.categories[0]));
    }
  }

  void _onLabelChanged() {
    if (lablesList.length > 0 && _selectedLableIndex != null) {
      _bloc.add(LableChanged(color_code: lablesList[_selectedLableIndex].color_code));
    } else {
      _bloc.add(LableChanged(color_code: lablesList[0].color_code));
    }
  }

  void _onFormSubmitted() {
    if (_nameController.text.length > 0 &&
        cats.categories[_selectedCategoryIndex] != null &&
        lablesList[_selectedLableIndex] != null &&
        _descriptionController.text.length > 0) {
      _bloc.add(Submitted(
          title: _nameController.text,
          type: cats.categories[_selectedCategoryIndex],
          code: lablesList[_selectedLableIndex].color_code,
          desc: _descriptionController.text));
    }
  }
}
