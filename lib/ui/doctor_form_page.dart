import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './button.dart';

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
  TextEditingController idNo = TextEditingController();
  TextEditingController mpln = TextEditingController();
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
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formkey,
          child: ListView(
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
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "doctorcare@mail.com",
                  ),
                  controller: emailcontrol,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty) return "Email is required";
                  }),
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                  hintText: "Name Surname",
                  labelText: "Name - Surname",
                ),
                validator: (value) {
                  int count = 0;
                  if (value.isEmpty) return "Name is required";
                  for (int i = 0; i < value.length; i++) {
                    if (value[i] == " " && i != 0 && i != value.length - 1) {
                      count += 1;
                    }
                  }
                  if (count != 1) {
                    return "Please fill name correctly";
                  }
                },
              ),
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
                  decoration: InputDecoration(labelText: "Re-Password"),
                  obscureText: true,
                  controller: passconfcontrol,
                  validator: (value) {
                    if (value.isEmpty)
                      return "Password is required";
                    else if (passcontrol.text != passconfcontrol.text)
                      return "Password does not match";
                  }),
              TextFormField(
                decoration: InputDecoration(labelText: "Identification Number"),
                controller: idNo,
                validator: (value) {
                  if (value.isEmpty)
                    return "ID No. is required";
                  else if (value.length != 13)
                    return "ID No. must be 13 character";
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: "Medical professional license number"),
                controller: mpln,
                validator: (value) {
                  if (value.isEmpty) return "ID No. is required";
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Limit patient"),
                controller: limit,
                validator: (value) {
                  if (int.parse(value) < 0)
                    return "Limit patient must more than 0";
                },
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
              CustomButton(
                text: 'Register',
                height: 40,
                onPressed: (){
                  if(_formkey.currentState.validate()){
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
                            'idNo': idNo.text,
                            'isValidated': 'false',
                            'photoUrl':
                                'https://firebasestorage.googleapis.com/v0/b/projecmobile-ab028.appspot.com/o/test.jpg?alt=media&token=55aafcc7-dd2c-4754-84c9-d24adad591d1'
                          });
                          Firestore.instance
                              .collection('Patient')
                              .document(user.uid)
                              .setData({
                            'email': user.email,
                            'uid': user.uid,
                            'role': "Doctor",
                            'Name': name.text,
                            'Department': _department,
                            'limit': limit.text,
                            'status': "online",
                            'idNo': idNo.text,
                            'isValidated': 'false',
                            'photoUrl':
                                'https://firebasestorage.googleapis.com/v0/b/projecmobile-ab028.appspot.com/o/test.jpg?alt=media&token=55aafcc7-dd2c-4754-84c9-d24adad591d1'
                          }).then((value) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacementNamed('/');
                          }).catchError((e) {
                            print(e);
                          });
                        });
                  }
                  
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}