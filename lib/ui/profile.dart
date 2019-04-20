import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../services/usermanagement.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  var profilePicUrl =
      'https://firebasestorage.googleapis.com/v0/b/projecmobile-ab028.appspot.com/o/myimage.jpg?alt=media&token=ef7440e0-9257-41e6-b61c-43ae01a54ea4';

  var nickName = 'Tom';

  bool isLoading = false;

  File selectedImage;

  UserManagement userManagement = new UserManagement();

  String newNickName;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        // profilePicUrl = user.photoUrl;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future selectPhoto() async {
    setState(() {
      isLoading = true;
    });
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = tempImage;
      // uploadImage();
    });
  }

  // Future uploadImage() async {
  //   var randomno = Random(25);
  //   final StorageReference firebaseStorageRef = FirebaseStorage.instance
  //       .ref()
  //       .child('profilepics/${randomno.nextInt(5000).toString()}.jpg');
  //   StorageUploadTask task = firebaseStorageRef.putFile(selectedImage);

  //   task.future.then((value) {
  //     setState(() {
  //       userManagement
  //           .updateProfilePic(value.downloadUrl.toString())
  //           .then((val) {
  //         setState(() {
  //           profilePicUrl = value.downloadUrl.toString();
  //           isLoading = false;
  //         });
  //       });
  //     });
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  getLoader() {
    return isLoading
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
            ],
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
      children: <Widget>[

        Positioned(
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
                            image: NetworkImage(profilePicUrl),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 7.0, color: Colors.black)
                        ])),
                SizedBox(height: 20.0),
                getLoader(),
                SizedBox(height: 65.0),
                Text(
                  "YA",
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
                                'Edit Photo',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            ))
      ],
    ));
  }
}
