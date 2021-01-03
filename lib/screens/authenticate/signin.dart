import 'package:flutter/material.dart';
//import 'package:trashtroopers/models/admin.dart';
import 'package:trashtroopers/screens/authenticate/register.dart';
import 'package:trashtroopers/services/auth.dart';
import 'package:trashtroopers/shared/constant.dart';
import 'package:trashtroopers/shared/loading.dart';
import 'package:trashtroopers/screens/home/adminpage.dart';

class signin extends StatefulWidget {
  final Function toggleview;
  signin({this.toggleview});
  @override
  _signinState createState() => _signinState();
}

class _signinState extends State<signin> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool load = false;
  String email = '';
  String pass = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return load
        ? loading()
        : Scaffold(
            backgroundColor: Colors.blue.shade700,
            appBar: AppBar(
              backgroundColor: Colors.blue.shade700,
              title: Text('Welcome to TrashTroopers'),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      widget.toggleview();
                    },
                    icon: Icon(Icons.person),
                    label: Text('Register'))
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/trash.png'),
                      fit: BoxFit.cover)),
              padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 60.0),
              child: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40.0,
                      child: TextFormField(
                        decoration: textDecoration.copyWith(hintText: 'Email'),
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email address' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      height: 40.0,
                      child: TextFormField(
                        decoration:
                            textDecoration.copyWith(hintText: 'Password'),
                        obscureText: true,
                        validator: (val) => val.isEmpty
                            ? 'Enter a password atleast 6+ chars long'
                            : null,
                        onChanged: (val) {
                          setState(() => pass = val);
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      height: 40.0,
                      child: RaisedButton(
                          child: Text(
                            'Sign in',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.deepPurpleAccent[400],
                          onPressed: () async {
                            if (_formkey.currentState.validate()) {
                              setState(() => load = true);
                              dynamic result =
                                  await _auth.signwitheandp(email, pass);
                              if (result == null) {
                                setState(() {
                                  error =
                                      'Could not sign in with those credentials';
                                  load = false;
                                });
                              }
                            }
                          }),
                    ),
                    SizedBox(
                      height: 18.0,
                      child: Text(
                        error,
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
