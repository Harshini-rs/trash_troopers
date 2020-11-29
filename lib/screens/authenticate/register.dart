import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trashtroopers/services/auth.dart';
import 'package:trashtroopers/screens/authenticate/authenticate.dart';
import 'package:trashtroopers/shared/constant.dart';
import 'package:trashtroopers/shared/loading.dart';

class register extends StatefulWidget {
  final Function toggleview;
  register({this.toggleview});
  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  String email = '';
  String pass = '';
  String error = '';
  bool load = false;

  @override
  Widget build(BuildContext context) {
    return load
        ? loading()
        : Scaffold(
            backgroundColor: Colors.blue.shade700,
            appBar: AppBar(
              backgroundColor: Colors.blue.shade700,
              title: Text('Sign up to TrashTroopers'),
              actions: <Widget>[
                FlatButton.icon(
                  onPressed: () {
                    setState(() {
                      widget.toggleview();
                    });
                  },
                  icon: Icon(Icons.person),
                  label: Text('Sign in'),
                )
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
                        validator: (val) => val.length < 6
                            ? 'Enter a password atleast 6+ chars long'
                            : null,
                        obscureText: true,
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
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.deepPurpleAccent[400],
                        onPressed: () async {
                          if (_formkey.currentState.validate()) {
                            setState(() {
                              load = true;
                            });
                            dynamic result =
                                await _auth.regwitheandp(email, pass);
                            if (result == null) {
                              setState(() {
                                load = false;
                                error =
                                    'Please enter a valid email or password';
                              });
                            }
                          }
                        },
                      ),
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
