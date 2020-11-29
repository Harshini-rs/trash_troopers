import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trashtroopers/models/user.dart';
import 'package:trashtroopers/screens/authenticate/authenticate.dart';
import 'package:trashtroopers/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return home();
    }
  }
}
