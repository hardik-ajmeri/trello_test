import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trellotest/app/model/board_category.dart';
import 'package:trellotest/app/model/board_list.dart';
import 'package:trellotest/app/model/hl_board.dart';
import 'fs_constants.dart' as FSConstants;

class FSHelper {
  Firestore _firestore;
  static final FSHelper _instance = FSHelper._internal();

  factory FSHelper() {
    return _instance;
  }

  FSHelper._internal() {
    _firestore = Firestore.instance;
  }

  Future<DocumentReference> addNewBoard(HLBoard board) async {
    try {
      DocumentReference ref = await _firestore.collection(FSConstants.FS_Boards).add(board.toJson());
      print("New Board ID: " + ref.documentID);
      return ref;
    } catch(error){
      print(error.toString());
      return null;
    }
  }

  Stream<QuerySnapshot> getCategories() {
    try {
      return _firestore.collection(FSConstants.FS_BoardCategory).snapshots();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Stream<QuerySnapshot> getLables() {
    try {
      return _firestore.collection(FSConstants.FS_Lables).snapshots();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Stream<QuerySnapshot> getPersonalBoards() {
    try {
      return _firestore.collection(FSConstants.FS_Boards).where('category', isEqualTo: "Personal").snapshots();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Stream<QuerySnapshot> getWorkBoards() {
    try {
      return  _firestore.collection(FSConstants.FS_Boards).where("category", isEqualTo: "Work").snapshots();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
