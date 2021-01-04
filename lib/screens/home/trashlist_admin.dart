import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trashtroopers/models/trash.dart';
import 'package:trashtroopers/screens/home/adminTile.dart';

import 'adminTile.dart';

class trashlist_admin extends StatefulWidget {
  @override
  _trashlist_adminState createState() => _trashlist_adminState();
}

class _trashlist_adminState extends State<trashlist_admin> {
  @override
  Widget build(BuildContext context) {
    final tra = Provider.of<List<trash>>(context) ?? [];

    return ListView.builder(
      itemCount: tra.length,
      itemBuilder: (context, index) {
        return adminTile(tr: tra[index]);
      },
    );
  }
}
