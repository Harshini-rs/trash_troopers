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
import 'package:geocoder/geocoder.dart';

class settingsForm extends StatefulWidget {
  @override
  _settingsFormState createState() => _settingsFormState();
}

class _settingsFormState extends State<settingsForm> {
  final _formKey = GlobalKey<FormState>();
  Coordinates _currentPosition;
  String _name, _location, _complaint;
  var _file, first, addresses;
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    final File file = File(pickedFile.path);

    setState(() {
      _image = file;
    });
    uploadFile();
  }

  void getloc() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    _currentPosition = new Coordinates(position.latitude, position.longitude);
  }

  _getAddressFromLatLng() async {
    addresses =
        await Geocoder.local.findAddressesFromCoordinates(_currentPosition);
    first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
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
                Text(
                  'Enter Location:',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                TextFormField(
                  initialValue: userData.location,
                  decoration: textDecoration,
                  onChanged: (val) => setState(() => _location = val),
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
                      getloc();
                    });
                  },
                  tooltip: 'Pick Image',
                  child: Icon(Icons.add_a_photo),
                ),
                RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await Dbservice(uid: user.uid).updateUserdata(
                        _name ?? userData.name,
                        _location ?? first,
                        _complaint ?? userData.complaint,
                        await _file ?? userData.file,
                      );
                      Navigator.pop(context);
                    }
                  },
                  color: Colors.pink[400],
                  child: Text('Update', style: TextStyle(color: Colors.white)),
                )
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
