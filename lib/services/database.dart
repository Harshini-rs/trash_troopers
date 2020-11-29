import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:trashtroopers/models/trash.dart';
import 'package:trashtroopers/models/user.dart';
import 'package:trashtroopers/models/user.dart';
import 'package:trashtroopers/models/user.dart';
import 'package:trashtroopers/models/user.dart';

class Dbservice {
  final String uid;
  Dbservice({this.uid});

  final CollectionReference ttcollection =
      Firestore.instance.collection('trash');

  //Add File image
  Future updateUserdata(
      String name, String location, String complaint, String file) async {
    return await ttcollection.document(uid).setData({
      'name': name,
      'location': location,
      'complaint': complaint,
      'file': file,
    });
  }

  //Add FIle image
  List<trash> _trashlistFromSnap(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return trash(
        name: doc.data['name'] ?? '',
        location: doc.data['location'] ?? '',
        complaint: doc.data['complaint'] ?? '',
        file: doc.data['file'] ?? '',
      );
    }).toList();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      location: snapshot.data['location'],
      complaint: snapshot.data['complaint'],
    );
  }

  Stream<List<trash>> get tt {
    return ttcollection.snapshots().map(_trashlistFromSnap);
  }

  Stream<UserData> get userData {
    return ttcollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
