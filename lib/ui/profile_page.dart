import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  final String userId;
  Profile({Key key, this.userId}) : super(key: key);
  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  var photoUrl = '';

  File selectedImage;

  SharedPreferences prefs;

  String id = '';
  String name = '';

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    name = prefs.getString('name' ?? '');

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
    someMethod().then((id) {
      String fileName = id;
      StorageReference reference =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = reference.putFile(selectedImage);
      StorageTaskSnapshot storageTaskSnapshot;
      uploadTask.onComplete.then((value) {
        if (value.error == null) {
          storageTaskSnapshot = value;
          storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
            photoUrl = downloadUrl;
            print(photoUrl);
            Firestore.instance
                .collection('users')
                .document(id)
                .updateData({'photoUrl': photoUrl});
            setState(() {
              photoUrl = downloadUrl;
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
      children: <Widget>[
        FutureBuilder(
          future: Firestore.instance.collection('users').document(id).get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              return buildImage(context, snapshot.data.data["photoUrl"]);
            } else {
              return Text("No data");
            }
          },
        ),
      ],
    ));
  }

  Positioned buildImage(BuildContext context, String photoUrl) {
    return Positioned(
        width: 350.0,
        left: 4.0,
        top: MediaQuery.of(context).size.height / 5,
        child: Column(
          children: <Widget>[
            Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                    color: Colors.red,
                    image: DecorationImage(
                        image: NetworkImage(photoUrl), fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(75.0)),
                    boxShadow: [
                      BoxShadow(blurRadius: 7.0, color: Colors.black)
                    ])),
            SizedBox(height: 20.0),
            SizedBox(height: 65.0),
            Text(
              name,
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'),
            ),
            SizedBox(height: 15.0),
            Text(
              'Actor',
              style: TextStyle(
                  fontSize: 17.0,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Montserrat'),
            ),
            SizedBox(height: 75.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    height: 30.0,
                    width: 95.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.blueAccent,
                      color: Colors.blue,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: selectPhoto,
                        child: Center(
                          child: Text(
                            id,
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ));
  }

  someMethod() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String id = user.uid;
    return id;
  }
}