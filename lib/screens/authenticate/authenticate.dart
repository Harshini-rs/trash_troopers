import 'package:flutter/material.dart';
import 'package:trashtroopers/screens/authenticate/register.dart';
import 'package:trashtroopers/screens/authenticate/signin.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSign = true;

  void toggleview() {
    setState(() => showSign = !showSign);
  }

  @override
  Widget build(BuildContext context) {
    if (showSign) {
      return signin(toggleview: toggleview);
    } else {
      return register(toggleview: toggleview);
    }
  }
}
