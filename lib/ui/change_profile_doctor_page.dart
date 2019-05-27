import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'button.dart';

class ChangeDoctorProfile extends StatefulWidget {
  final String userId;
  ChangeDoctorProfile({Key key, this.userId}) : super(key: key);
  @override
  _ChangeDoctorProfileState createState() => new _ChangeDoctorProfileState();
}

class _ChangeDoctorProfileState extends State<ChangeDoctorProfile> {
  TextEditingController new_name = TextEditingController();
  TextEditingController limit = TextEditingController();
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
              .collection('Doctor')
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
          title: Text('Edit Profile'),
        ),
        body: new Stack(
          children: <Widget>[
            FutureBuilder(
              future:
                  Firestore.instance.collection('Doctor').document(id).get(),
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
                height: 30.0,
                width: 120.0,
                child: CustomButton(
                  text: "Change Picture",
                  width: 150,
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color.fromRGBO(200, 219, 241, 1),
                      Color.fromRGBO(169, 201, 239, 1)
                    ],
                    begin: FractionalOffset(0, 0),
                    end: FractionalOffset(0.6, 0),
                    stops: [0.0, 1.0],
                  ),
                  height: 20,
                  onPressed: selectPhoto,
                )),
          ],
        ),
        SizedBox(height: 20.0),
        Padding(
          padding: EdgeInsets.only(left: 50, right: 50, bottom: 5),
          child: TextFormField(
              decoration: InputDecoration(
                  labelText: "Name: ", labelStyle: TextStyle(fontSize: 15)),
              controller: new_name,
              validator: (value) {
                if (value.isEmpty) return "Name is required";
              }),
        ),
        Padding(
          padding: EdgeInsets.only(left: 50, right: 50, bottom: 30),
          child: TextFormField(
            keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Limit patient: ",
            labelStyle: TextStyle(fontSize: 15),
            ),
          controller: limit,
          validator: (value) {

            if(value.isEmpty)return "Please enter limit";
            if (int.parse(value) <= 0)
              return "Limit patient must more than 0";
          },
        ),
        ),
        CustomButton(
            text: "Save",
            width: 100,
            gradient: LinearGradient(
              colors: <Color>[
                Color.fromRGBO(200, 219, 241, 1),
                Color.fromRGBO(169, 201, 239, 1)
              ],
              begin: FractionalOffset(0, 0),
              end: FractionalOffset(0.6, 0),
              stops: [0.0, 1.0],
            ),
            height: 30,
            onPressed: () async {
              Firestore.instance
                              .collection('Doctor')
                              .document(id).updateData({
                                'name': new_name.text,
                                'limit': int.parse(limit.text).toString(),
                              });
              prefs = await SharedPreferences.getInstance();
              await prefs.setString('name', new_name.text);

              
              Navigator.pushNamed(context, '/home');
            }
            ),
      ],
    ));
  }
}
