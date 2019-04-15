import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './doctorform.dart';
import './patientform.dart';


class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formkey =GlobalKey<FormState>();
  TextEditingController emailcontrol =TextEditingController();
  TextEditingController passcontrol =TextEditingController();
  TextEditingController passconfcontrol =TextEditingController();
  TextEditingController depart =TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register New Account"),
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.accessibility),
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => DoctorForm()));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.pan_tool),
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => PatientForm()));
                      
                    },)
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}