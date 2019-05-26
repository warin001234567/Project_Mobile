import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'button.dart';

class ChangeProfile extends StatefulWidget {
  final String userId;
  ChangeProfile({Key key, this.userId}) : super(key: key);
  @override
  _ChangeProfileState createState() => new _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  String photoUrl = '';

  File selectedImage;

  SharedPreferences prefs;

  String id = '';
  String name = '';
  String role = '';
  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    name = prefs.getString('name' ?? '');
    role = prefs.getString('role' ?? '');
    photoUrl = prefs.getString('photoUrl' ?? '');

    // Force refresh input
    setState(() {});
  }

  Future selectPhoto() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = tempImage;
      uploadImage();
    });
  }

  Future uploadImage() async {
    String fileName = id;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(selectedImage);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          print(photoUrl);
          Firestore.instance
              .collection('Patient')
              .document(id)
              .updateData({'photoUrl': photoUrl});
          setState(() {
            photoUrl = downloadUrl;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: new Stack(
          children: <Widget>[
            FutureBuilder(
              future:
                  Firestore.instance.collection('Patient').document(id).get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return buildImage(context, snapshot.data.data["photoUrl"]);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ));
  }

  Widget buildImage(BuildContext context, String photoUrl) {
    return Center(
        child: Column(
      children: <Widget>[
        SizedBox(height: 60.0),
        Container(
            width: 150.0,
            height: 150.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(photoUrl), fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(75.0)),
                boxShadow: [BoxShadow(blurRadius: 7.0, color: Colors.black)])),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                height: 40.0,
                width: 120.0,
                child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  shadowColor: Colors.blueAccent,
                  color: Colors.blue,
                  elevation: 7.0,
                  child: GestureDetector(
                    onTap: selectPhoto,
                    child: Center(
                      child: Text(
                        'Change Picture',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Montserrat'),
                      ),
                    ),
                  ),
                )),
          ],
        ),
        SizedBox(height: 20.0),
        Column(children: <Widget>[
          Text("Name"),
                  TextField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 60.0),
              
              prefixText: 'Name : '),
              ),
        ],),
        SizedBox(height: 15.0),
        Text(
          role,
          style: TextStyle(
              fontSize: 17.0,
              fontStyle: FontStyle.italic,
              fontFamily: 'Montserrat'),
        ),
      ],
    ));
  }
}