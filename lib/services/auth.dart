import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
//import 'package:trashtroopers/models/admin.dart';
import 'package:trashtroopers/models/user.dart';
import 'package:trashtroopers/services/database.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class AuthService {
  static bool admin = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userfromfirebase(FirebaseUser user, bool adm) {
    print(admin);
    return (user != null) ? User(uid: user.uid, admin: adm) : null;
  }

  Future signinanon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future regwitheandp(String email, String pass) async {
    try {
      if (email.contains('admin')) {
        admin = true;
        AuthResult result = await _auth.createUserWithEmailAndPassword(
            email: email, password: pass);
        FirebaseUser user = result.user;
        return _userfromfirebase(user, true);
      } else {
        admin = false;
        AuthResult result = await _auth.createUserWithEmailAndPassword(
            email: email, password: pass);
        FirebaseUser user = result.user;
        //Add image File
        //await Dbservice(uid: user.uid).updateUserdata('null', 'null', 'null');
        return _userfromfirebase(user, false);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signwitheandp(String email, String pass) async {
    try {
      if (email.contains('admin')) {
        admin = true;
        AuthResult result = await _auth.signInWithEmailAndPassword(
            email: email, password: pass);
        FirebaseUser user = result.user;
        return _userfromfirebase(user, true);
      } else {
        admin = false;
        AuthResult result = await _auth.signInWithEmailAndPassword(
            email: email, password: pass);
        FirebaseUser user = result.user;
        return _userfromfirebase(user, false);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<User> get user {
    print(admin);
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userfromfirebase(user, admin));
  }
}
