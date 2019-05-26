import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'button.dart';

class Profile extends StatefulWidget {
  final String userId;
  Profile({Key key, this.userId}) : super(key: key);
  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  String photoUrl = '';
  String name_format = '';
  String id = '';
  String name = '';
  String role = '';

  File selectedImage;

  SharedPreferences prefs;
  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    name = prefs.getString('name' ?? '');
    role = prefs.getString('role' ?? '');
    photoUrl = prefs.getString('photoUrl' ?? '');
    // format name
    for (int i = 0; i < name.length; i++) {
      if (i == 0) {
        name_format += name[i].toUpperCase();
      } else if (name[i-1] == ' ') {
        name_format += name[i].toUpperCase();
      } else {
        name_format += name[i];
      }
    }
    // Force refresh input
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    readLocal();
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
      StorageReference reference =
          FirebaseStorage
          .instance
          .ref()
          .child(fileName);
      StorageUploadTask uploadTask = reference.putFile(selectedImage);
      StorageTaskSnapshot storageTaskSnapshot;
      uploadTask.onComplete.then((value) {
        if (value.error == null) {
          storageTaskSnapshot = value;
          storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
            photoUrl = downloadUrl;
            print(photoUrl);
            Firestore.instance
                .collection(role)
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
      body: new Stack(
      children: <Widget>[
        FutureBuilder(
          future: Firestore.instance.collection(role).document(id).get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child:CircularProgressIndicator()

              );
            } else {
              return buildImage(context, snapshot.data.data["photoUrl"]);
              
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
            SizedBox(height: 80.0),
            Text(
              'Profile',
              style: TextStyle(
                fontFamily: 'Quicksand Bold',
                fontSize: 35,
                color: Color.fromRGBO(125, 145, 193, 1)),
            ),
            SizedBox(height: 40.0),
            Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                    
                    image: DecorationImage(
                        image: NetworkImage(photoUrl), fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(75.0)),
                    boxShadow: [
                      BoxShadow(blurRadius: 7.0, color: Colors.black)
                    ])),
                                SizedBox(height: 20.0),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: <Widget>[
            //     Container(
            //         height: 40.0,
            //         width: 120.0,
            //         child: Material(
            //           borderRadius: BorderRadius.circular(20.0),
            //           shadowColor: Colors.blueAccent,
            //           color: Colors.blue,
            //           elevation: 7.0,
            //           child: GestureDetector(
            //             onTap: selectPhoto,
            //             child: Center(
            //               child: Text(
            //                 'Change Picture',
            //                 style: TextStyle(
            //                     color: Colors.white, fontFamily: 'Montserrat'),
            //               ),
            //             ),
            //           ),
            //         )),
            //   ],
            // ),
            SizedBox(height: 20.0),
            Text(
              name_format,
              style: TextStyle(
                fontFamily: 'Quicksand Bold',
                fontSize: 25,
                color: Color.fromRGBO(125, 145, 193, 1)),
            ),
            SizedBox(height: 15.0),
            Text(
              "Status: " + role,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontFamily: 'Quicksand Bold',
                fontSize: 15,
                color: Color.fromRGBO(125, 145, 193, 1)),
            ),
            SizedBox(height: 15.0),
            CustomButton(
              text: "Change Profile",
              width: 200,
              gradient: LinearGradient(
                colors: <Color>[Color.fromRGBO(200, 219, 241, 1), Color.fromRGBO(169, 201, 239, 1)],
                begin: FractionalOffset(0, 0),
                end: FractionalOffset(0.6, 0),
                stops: [0.0, 1.0],
              ),
              height: 50,
              onPressed: () {
                if (role == "Patient") {
                  Navigator.pushNamed(context, "/change_patient");
                } else {
                  Navigator.pushNamed(context, "/change_doctor");
                }
              },)
          ],
        ));
  }

}
