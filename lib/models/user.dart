import 'dart:io';

class User {
  final String uid;
  final bool admin;
  User({this.uid, this.admin});
}

class UserData {
  final String uid;
  final bool admin;
  final String name;
  final String location;
  final String complaint;
  final bool complete;
  var file;
  //Add file image
  UserData(
      {this.uid,
      this.admin,
      this.name,
      this.location,
      this.complaint,
      this.file,
      this.complete});
}

/*class AdminData{
  final String uid;
  final bool admin;
  final bool completed;

  AdminData({this.uid, this.admin, this.completed})
}*/
