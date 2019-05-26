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
    "MEDICINE",
    "PEDIATRIRC",
    "SURGICAL",
    "PRTHOPEDIC",
    "OBSTRETIC-GYNECOLOGY"
  ];
  String _department = "MEDICINE";
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
      body: Form(
          key: _formkey,
          child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 35, left: 15, right: 15),
            child: Column(
              children: <Widget>[
                Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.chevron_left,
                              color: Colors.grey,
                            ),
                            onPressed: (){
                            Navigator.pop(context);
                            },
                        ),
                      ]
                    ),
                  Padding(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: Column(
                      children: <Widget>[
                        Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                         Text(
                            'SIGN UP',
                            style: TextStyle(
                            fontFamily: 'Quicksand Bold',
                            fontSize: 35,
                            color: Color.fromRGBO(125, 145, 193, 1)),
                          ),
                      ],
                    ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(fontSize: 10),
                      hintText: "doctorcare@mail.com",
                    ),
                    controller: emailcontrol,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) return "Email is required";
                    }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    hintText: "Name Surname",
                    labelText: "Name - Surname",
                    labelStyle: TextStyle(fontSize: 10),
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
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(fontSize: 10),
                      ),
                    obscureText: true,
                    controller: passcontrol,
                    validator: (value) {
                      if (value.isEmpty)
                        return "Password is required";
                      else if (value.length < 8)
                        return "Password much more than 8";
                    }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Re-Password",
                      labelStyle: TextStyle(fontSize: 10),
                      ),
                    obscureText: true,
                    controller: passconfcontrol,
                    validator: (value) {
                      if (value.isEmpty)
                        return "Password is required";
                      else if (passcontrol.text != passconfcontrol.text)
                        return "Password does not match";
                    }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Identification Number",
                    labelStyle: TextStyle(fontSize: 10),
                    ),
                  controller: idNo,
                  validator: (value) {
                    if (value.isEmpty)
                      return "ID No. is required";
                    else if (value.length != 13)
                      return "ID No. must be 13 character";
                  },
                ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Medical professional license number",
                      labelStyle: TextStyle(fontSize: 10),
                      ),
                  controller: mpln,
                  validator: (value) {
                    if (value.isEmpty) return "ID No. is required";
                  },
                ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Limit patient",
                    labelStyle: TextStyle(fontSize: 10),
                    ),
                  controller: limit,
                  validator: (value) {

                    if(value.isEmpty)return "Please enter limit";
                    if (int.parse(value) <= 0)
                      return "Limit patient must more than 0";
                  },
                ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: 
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Departments",
                    labelStyle: TextStyle(fontSize: 13),
                  ),
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
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: 
                CustomButton(
                  text: 'Register',
                  height: 40,
                  gradient: LinearGradient(
                      colors: <Color>[Color.fromRGBO(200, 219, 241, 1), Color.fromRGBO(169, 201, 239, 1)],
                      begin: FractionalOffset(0, 0),
                      end: FractionalOffset(0.6, 0),
                      stops: [0.0, 1.0],
                  ),
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
                                'name': name.text,
                                'department': _department,
                                'limit': limit.text,
                                'status': "online",
                                'idNo': idNo.text,
                                'isValidated': 'false',
                                'photoUrl':
                                  'https://firebasestorage.googleapis.com/v0/b/projecmobile-ab028.appspot.com/o/test.jpg?alt=media&token=55aafcc7-dd2c-4754-84c9-d24adad591d1'
                              }).then((_)=>{
                                  Navigator.of(context).popUntil(ModalRoute.withName('/')),
                                  Navigator.of(context)
                                      .pushReplacementNamed('/')
                              });
                          }).catchError((onError)=>{
                            Scaffold.of(_formkey.currentContext)
	                              .showSnackBar(SnackBar(
	                            content: Text(onError.toString()),
	                              )
	                              )
                          });
                    }
                  },
                )
                ),
                ]
                    ),
              )
              ],
            ),
          )
        )
      ),
    );
  }
}