import 'dart:io';

class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String location;
  final String complaint;
  var file;
  //Add file image
  UserData({this.uid, this.name, this.location, this.complaint, this.file});
}
