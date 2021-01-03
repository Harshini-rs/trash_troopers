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
  Future updateUserdata(String uid, String name, String location,
      String complaint, String file, String complete) async {
    return await ttcollection.document(uid).setData({
      'uid': uid,
      'name': name,
      'location': location,
      'complaint': complaint,
      'file': file,
      'complete': complete,
    });
  }

  Future updateUserdata_a(String complete) async {
    return await ttcollection.document(uid).updateData({'complete': complete});
  }

  //Add FIle image
  List<trash> _trashlistFromSnap(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return trash(
        uid: doc.data['uid'],
        name: doc.data['name'] ?? '',
        location: doc.data['location'] ?? '',
        complaint: doc.data['complaint'] ?? '',
        file: doc.data['file'] ?? '',
        complete: doc.data['complete'] ?? '',
      );
    }).toList();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      admin: snapshot.data['admin'],
      name: snapshot.data['name'],
      location: snapshot.data['location'],
      complaint: snapshot.data['complaint'],
      complete: snapshot.data['complete'],
    );
  }

  Stream<List<trash>> get tt {
    return ttcollection.snapshots().map(_trashlistFromSnap);
  }

  Stream<UserData> get userData {
    return ttcollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
