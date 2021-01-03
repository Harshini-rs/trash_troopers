import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trashtroopers/models/user.dart';
import 'package:trashtroopers/services/database.dart';
import 'package:trashtroopers/shared/constant.dart';
import 'dart:io';
import 'package:characters/characters.dart';
import 'package:trashtroopers/shared/loading.dart';
import 'package:path/path.dart' as Path;
import 'package:geolocator/geolocator.dart';

class settingsForm extends StatefulWidget {
  @override
  _settingsFormState createState() => _settingsFormState();
}

class _settingsFormState extends State<settingsForm> {
  final _formKey = GlobalKey<FormState>();
  String _name, _location, _complaint;
  var _file, first, addresses;
  Position _currentPosition;
  static String _currentAddress;
  File _image;
  final picker = ImagePicker();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    final File file = File(pickedFile.path);

    setState(() {
      _image = file;
    });
    uploadFile();
  }

  Future getloc() async {
    //LocationPermission permission = await geolocator.requestPermission();
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
      print(_currentPosition);
    }).catchError((e) {
      print(e);
    });
  }

  Future _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
      print(_currentAddress);
    } catch (e) {
      print(e);
    }
  }

  Widget enableUpload() {
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(_image, height: 100.0, width: 100.0),
        ],
      ),
    );
  }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('pics/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    _file = await storageReference.getDownloadURL();
    print(_file);
  }
  /*setState(() {
        _file = fileURL.toString();
        print(_file);
      });*/

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream: Dbservice(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;

          return Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Text(
                  'Update your data',
                  style: TextStyle(fontSize: 18.0, color: Colors.red),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Enter Name:',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                TextFormField(
                  initialValue: userData.name,
                  decoration: textDecoration,
                  validator: (val) =>
                      val.isEmpty ? "Please enter your name" : null,
                  onChanged: (val) => setState(() => _name = val),
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  child: Text('Get Location',
                      style: TextStyle(color: Colors.white)),
                  color: Colors.pink[400],
                  onPressed: () async {
                    await getloc();
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(_currentAddress ?? 'Press button to get your location'),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Enter Location:',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                //Text(_currentAddress),
                TextFormField(
                  initialValue: _currentAddress ??
                      'Do not fill in if the automatic location is correct!!!',
                  decoration: textDecoration,
                  onChanged: (val) {
                    setState(() {
                      _location = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Enter Complaint:',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                TextFormField(
                  initialValue: userData.complaint,
                  decoration: textDecoration,
                  validator: (val) =>
                      val.isEmpty ? "Please enter your complaint" : null,
                  onChanged: (val) => setState(() => _complaint = val),
                ),
                Center(
                  child:
                      _image == null ? Text('Select an image') : enableUpload(),
                ),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      getImage();
                    });
                  },
                  tooltip: 'Pick Image',
                  child: Icon(Icons.add_a_photo),
                ),
                RaisedButton(
                  onPressed: () async {
                    //print(_currentAddress);
                    if (_formKey.currentState.validate()) {
                      await Dbservice(uid: user.uid).updateUserdata(
                        user.uid,
                        _name ?? userData.name,
                        _location ?? _currentAddress,
                        _complaint ?? userData.complaint,
                        await _file ?? userData.file,
                        'false',
                      );
                      Navigator.pop(context);
                    }
                  },
                  color: Colors.pink[400],
                  child: Text('Update', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        } else {
          return loading();
        }
      },
    );
  }
}
