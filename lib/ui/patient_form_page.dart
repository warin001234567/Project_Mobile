import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './button.dart';

class PatientForm extends StatefulWidget {
  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController emailcontrol = TextEditingController();
  TextEditingController passcontrol = TextEditingController();
  TextEditingController passconfcontrol = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController symptom = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Padding(
          padding: EdgeInsets.all(18),
          child: Form(
              key: _formkey,
              child: Padding(
                padding: EdgeInsets.only(top: 35, left: 20, right: 20),
                child: Column(
                  children: <Widget>[
                    Text(
                      'SIGN UP',
                      style: TextStyle(
                          fontFamily: 'Quicksand Bold',
                          fontSize: 35,
                          color: Colors.blueGrey),
                    ),
                    // Row(
                    //   children: <Widget>[
                    //     IconButton(
                    //       icon: Icon(Icons.accessibility),
                    //       onPressed: () {
                    //         Firestore.instance.collection('/Doctor');
                    //       },
                    //     ),
                    //     IconButton(
                    //       icon: Icon(Icons.pan_tool),
                    //       onPressed: () {
                    //         Firestore.instance.collection('/Pantial');
                    //       },)
                    //   ],
                    // ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(fontSize: 11)),
                        controller: emailcontrol,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isEmpty) return "Email is required";
                        }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(fontSize: 11)),
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
                            labelText: "Password",
                            labelStyle: TextStyle(fontSize: 11)),
                        obscureText: true,
                        controller: passconfcontrol,
                        validator: (value) {
                          if (value.isEmpty)
                            return "Password is required";
                          else if (passcontrol.text != passconfcontrol.text)
                            return "Password Not Same";
                        }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "Name",
                            labelStyle: TextStyle(fontSize: 11)),
                        controller: name,
                        validator: (value) {
                          if (value.isEmpty) return "Name is required";
                        }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "Symptom",
                            labelStyle: TextStyle(fontSize: 11)),
                        controller: symptom,
                        validator: (value) {
                          if (value.isEmpty) return "Symptom is required";
                        }),
                    ),                    
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                      child:  CustomButton(
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
                                    .collection('/users')
                                    .document(user.uid)
                                    .setData({
                                  'email': user.email,
                                  'uid': user.uid,
                                  'role': "Patient",
                                  'Name': name.text,
                                  'check': 'false',
                                  'Symptom': symptom.text,
                                  'photoUrl':
                                      'https://firebasestorage.googleapis.com/v0/b/projecmobile-ab028.appspot.com/o/test.jpg?alt=media&token=55aafcc7-dd2c-4754-84c9-d24adad591d1'
                                }).then((value) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context)
                                      .pushReplacementNamed('/');
                                }).catchError((e) {
                                  print(e);
                                });
                              });
                          }
                          
                        },
                      )
                )
                  ],
                ),
              ))),
    );
  }
}
