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
      body: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child:Padding(
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
                            labelStyle: TextStyle(fontSize: 10)),
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
                            labelStyle: TextStyle(fontSize: 10)),
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
                            labelText: "Confrim Password",
                            labelStyle: TextStyle(fontSize: 10)),
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
                            labelStyle: TextStyle(fontSize: 10)),
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
                            labelStyle: TextStyle(fontSize: 10)),
                        controller: symptom,
                        validator: (value) {
                          if (value.isEmpty) return "Symptom is required";
                        }),
                    ),                   
                    Padding(
                      padding: EdgeInsets.only(top: 35,bottom: 15),
                      child:  CustomButton(
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
                                    .collection('Patient')
                                    .document(user.uid)
                                    .setData({
                                  'email': user.email,
                                  'uid': user.uid,
                                  'role': "Patient",
                                  'name': name.text,
                                  'check': '',
                                  'symptom': symptom.text,
                                  'photoUrl':
                                      'https://firebasestorage.googleapis.com/v0/b/projecmobile-ab028.appspot.com/o/test.jpg?alt=media&token=55aafcc7-dd2c-4754-84c9-d24adad591d1'
                                }).then((value) {
                                  Navigator.of(context).popUntil(ModalRoute.withName('/'));
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
                      )
                    ),
                    
                  ],),
                )
              )
          )
      );
  }
}
