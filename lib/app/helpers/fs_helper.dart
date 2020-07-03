import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:trellotest/app/model/hl_board.dart';
import 'package:trellotest/app/model/hl_card.dart';
import 'package:trellotest/app/model/hl_task.dart';
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

  ////////////////////////////////////////////////////////////////////////
  //////////////////////////// Get Data //////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
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

  Stream<QuerySnapshot> getCards() {
    try {
      return _firestore.collection(FSConstants.FS_Cards).snapshots();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Stream<QuerySnapshot> getTasks() {
    try {
      return _firestore.collection(FSConstants.FS_Tasks).snapshots();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }


  ////////////////////////////////////////////////////////////////////////
  //////////////////////////// Add Data //////////////////////////////////
  ////////////////////////////////////////////////////////////////////////

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

  Future<DocumentReference> addNewCard(HLCard card) async {
    try {
      DocumentReference ref = await _firestore.collection(FSConstants.FS_Cards).add(card.toJson());
      print("New Card ID: " + ref.documentID);
      return ref;
    } catch(error){
      print(error.toString());
      return null;
    }
  }

  Future<DocumentReference> addNewTask(HLTask task) async {
    try {
      DocumentReference ref = await _firestore.collection(FSConstants.FS_Tasks).add(task.toJson());
      print("New Task ID: " + ref.documentID);
      return ref;
    } catch(error){
      print(error.toString());
      return null;
    }
  }


  ////////////////////////////////////////////////////////////////////////
  /////////////////////////// Update Data ////////////////////////////////
  ////////////////////////////////////////////////////////////////////////

  Future<void> updateBoard(HLBoard board) async {
    try {
      QuerySnapshot qs = await _firestore.collection(FSConstants.FS_Boards).where("title", isEqualTo: board.title).getDocuments();
      if (qs != null) {
        return qs.documents[0].reference.updateData(board.toJson());
      }
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<void> updateTasks(HLCard card) async {
    try {
      QuerySnapshot qs = await _firestore.collection(FSConstants.FS_Cards).where("title", isEqualTo: card.title).getDocuments();
      if (qs != null) {
        return qs.documents[0].reference.updateData(card.toJson());
      }
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<void> updateTask(String documentId, HLTask task) async {
    try {
      await _firestore.document(documentId).updateData(task.toJson());
    } catch(error) {
      print(error.toString());
    }
  }

  Future<void> updateCard(String documentId, HLCard card) async {
    try {
      await _firestore.document(documentId).updateData(card.toJson());
    } catch(error) {
      print(error.toString());
    }
  }

}
