import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './doctor_form_page.dart';
import './patient_form_page.dart';


class RoleScreen extends StatefulWidget {
  @override
  RoleScreenState createState() => RoleScreenState();
}

class RoleScreenState extends State<RoleScreen> {
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
        title: Text(
          "Register New Account",
        ),
      ),
      body: Center(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Register As',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child:GestureDetector(
                        onTap: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => DoctorForm()));
                        },
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(10.0),
                          child: Image.asset(
                            'res/images/doc-select.jpg',
                            height: 120.0,
                            width: 120.0,
                            fit: BoxFit.fill
                          ),
                        )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50.0),
                      child: Text('Doctor'),
                    )
                  ]
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child:GestureDetector(
                        onTap: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => PatientForm()));
                        },
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(10.0),
                          child: Image.asset(
                            'res/images/pat-select.jpg',
                            height: 120.0,
                            width: 120.0,
                            fit: BoxFit.fill
                          ),
                        )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 49.0),
                      child: Text('Patient'),
                    )
                  ]
                ),
              ],
            ),
          ]
        )
      ),
    );
  }
}