import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:trashtroopers/models/trash.dart';
import 'package:flutter/material.dart';
import 'package:trashtroopers/services/database.dart';

class adminTile extends StatelessWidget {
  final trash tr;
  adminTile({this.tr});

  CircleAvatar status() {
    if (tr.complete == 'true') {
      if (tr.file.isNotEmpty) {
        return CircleAvatar(
          radius: 50.0,
          backgroundImage: NetworkImage(tr.file),
          child: Icon(
            Icons.check_circle,
            color: Colors.lightGreen,
            size: 70.0,
          ),
        );
      } else {
        return CircleAvatar(
          radius: 50.0,
          backgroundImage: AssetImage('assets/images/avatar.jpg'),
          child: Icon(
            Icons.check_circle,
            color: Colors.lightGreen,
          ),
        );
      }
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
        child: Container(
            child: Row(
          children: [
            status(),
            SizedBox(
              width: 10,
            ),
            Wrap(
              direction: Axis.vertical,
              //crossAxisAlignment: CrossAxisAlignment.start,
              //textDirection: TextDirection.ltr,
              children: [
                Text(tr.complaint),
                SizedBox(
                  height: 10,
                ),
                Text(tr.location),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      onPressed: () async {
                        if (tr.complete == 'false')
                          await Dbservice(uid: tr.uid).updateUserdata_a('true');
                        else
                          await Dbservice(uid: tr.uid)
                              .updateUserdata_a('false');
                      },
                      child: tr.complete == 'true'
                          ? Text('Undo')
                          : Text('Complete'),
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RaisedButton(
                      onPressed: () async {},
                      child: Text('View in maps'),
                      color: Colors.blue,
                    )
                  ],
                )
              ],
            ),
          ],
        )),
      ),
    );
  }
}
