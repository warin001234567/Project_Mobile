import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorForm extends StatefulWidget {
  @override
  _DoctorFormState createState() => _DoctorFormState();
}

class _DoctorFormState extends State<DoctorForm> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController emailcontrol = TextEditingController();
  TextEditingController passcontrol = TextEditingController();
  TextEditingController passconfcontrol = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController limit = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  File sampleImage;
  List<String> _departments = <String>[
    "Choose your Department",
    "MEDICINE",
    "PEDIATRIRC",
    "SURGICAL",
    "PRTHOPEDIC",
    "OBSTRETIC-GYNECOLOGY"
  ];
  String _department = "Choose your Department";
  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Register New Account"),
      ),
      body: WillPopScope(
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              Row(
                  // children: <Widget>[
                  //   IconButton(icon: Icon(Icons.add_a_photo), onPressed: () {
                  //     getImage();
                  //   },
                  //   ),
                  // ],
                  ),
              TextFormField(
                  decoration: InputDecoration(labelText: "Email"),
                  controller: emailcontrol,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty) return "Email is required";
                  }),
              TextFormField(
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                  controller: passcontrol,
                  validator: (value) {
                    if (value.isEmpty)
                      return "Password is required";
                    else if (value.length < 8)
                      return "Password much more than 8";
                  }),
              TextFormField(
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                  controller: passconfcontrol,
                  validator: (value) {
                    if (value.isEmpty)
                      return "Password is required";
                    else if (passcontrol.text != passconfcontrol.text)
                      return "Password Not Same";
                  }),
              TextFormField(
                  decoration: InputDecoration(labelText: "Name"),
                  controller: name,
                  validator: (value) {
                    if (value.isEmpty) return "Name is required";
                  }),
              TextFormField(
                decoration: InputDecoration(labelText: "Limit patient"),
                controller: limit,
              ),
              InputDecorator(
                decoration: InputDecoration(
                    icon: Icon(Icons.lock), labelText: "Departments"),
                isEmpty: _department == '',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: _department,
                    isDense: true,
                    onChanged: (value) {
                      setState(() {
                        _department = value;
                      });
                    },
                    items: _departments.map(
                      (String value) {
                        return DropdownMenuItem<String>(
                          child: Text(value),
                          value: value,
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      child: Text("Register"),
                      onPressed: () {
                        auth
                            .createUserWithEmailAndPassword(
                                email: emailcontrol.text,
                                password: passcontrol.text)
                            .then((user) {
                          Firestore.instance
                              .collection('Doctor')
                              .document(user.uid)
                              .setData({
                            'email': user.email,
                            'uid': user.uid,
                            'role': "Doctor",
                            'Name': name.text,
                            'Department': _department,
                            'limit': limit.text,
                            'status': "online",
                            'photoUrl':
                                'https://firebasestorage.googleapis.com/v0/b/projecmobile-ab028.appspot.com/o/test.jpg?alt=media&token=55aafcc7-dd2c-4754-84c9-d24adad591d1'
                          });
                          Firestore.instance
                              .collection('/users')
                              .document(user.uid)
                              .setData({
                            'email': user.email,
                            'uid': user.uid,
                            'role': "Doctor",
                            'Name': name.text,
                            'Department': _department,
                            'limit': limit.text,
                            'status': "online",
                            'photoUrl':
                                'https://firebasestorage.googleapis.com/v0/b/projecmobile-ab028.appspot.com/o/test.jpg?alt=media&token=55aafcc7-dd2c-4754-84c9-d24adad591d1'
                          }).then((value) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacementNamed('/');
                          }).catchError((e) {
                            print(e);
                          });
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        onWillPop: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
