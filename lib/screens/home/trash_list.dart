import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trashtroopers/models/trash.dart';
import 'package:trashtroopers/screens/home/trash_tile.dart';

class trashlist extends StatefulWidget {
  @override
  _trashlistState createState() => _trashlistState();
}

class _trashlistState extends State<trashlist> {
  @override
  Widget build(BuildContext context) {
    final tra = Provider.of<List<trash>>(context) ?? [];

    return ListView.builder(
      itemCount: tra.length,
      itemBuilder: (context, index) {
        return trashTile(tr: tra[index]);
      },
    );
  }
}
