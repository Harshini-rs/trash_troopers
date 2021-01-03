import 'package:flutter/material.dart';
import 'package:trashtroopers/models/trash.dart';

class trashTile extends StatelessWidget {
  final trash tr;
  trashTile({this.tr});

  CircleAvatar status() {
    if (tr.complete == 'true') {
      return CircleAvatar(
        radius: 70.0,
        backgroundColor: Colors.lightGreenAccent,
        child: Icon(
          Icons.check_circle,
          color: Colors.lightGreen,
          size: 50.0,
        ),
      );
    } else if (tr.file.isNotEmpty) {
      return CircleAvatar(
        radius: 50.0,
        backgroundColor: Colors.brown,
        backgroundImage: NetworkImage(tr.file),
      );
    } else {
      return CircleAvatar(
        radius: 50.0,
        backgroundColor: Colors.brown,
        backgroundImage: AssetImage('assets/images/avatar.jpg'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: status(),
          title: Text(tr.complaint),
          subtitle: Text(tr.location),
        ),
      ),
    );
  }
}
