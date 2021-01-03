import 'package:flutter/material.dart';
import 'package:trashtroopers/models/user.dart';
import 'package:trashtroopers/screens/home/newpanel.dart';
import 'package:trashtroopers/screens/home/settings_form.dart';
import 'package:trashtroopers/services/auth.dart';
import 'package:trashtroopers/services/database.dart';
import 'package:provider/provider.dart';
import 'package:trashtroopers/models/trash.dart';
import 'trash_list.dart';

class home extends StatelessWidget {
  //final dynamic result;
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    void _showsettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 6.0),
              child: settingsForm(),
            );
          });
    }

    void _showNewPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 6.0),
              child: NewPanel(),
            );
          });
    }

    return StreamProvider<List<trash>>.value(
      value: Dbservice().tt,
      child: Scaffold(
        backgroundColor: Colors.blue.shade700,
        appBar: AppBar(
          backgroundColor: Colors.blue.shade700,
          title: Text('Trash Troopers'),
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () async {
                  await _auth.signout();
                },
                icon: Icon(
                  Icons.people,
                  color: Colors.white,
                ),
                label: Text(
                  'logout',
                  style: TextStyle(color: Colors.white),
                )),
            FlatButton.icon(
                onPressed: () => _showsettingsPanel(),
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                label: Text(
                  'Settings',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/grass.jpg'),
                    fit: BoxFit.cover)),
            child: trashlist()),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add_to_photos),
            onPressed: () {
              _showNewPanel();
            }),
      ),
    );
  }
}
