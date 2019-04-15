import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './services/usermanagement.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  FirebaseAuth _auth =FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                controller: emailcontroller,
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  if(value.isEmpty) return "Email is required";
                }
              ),
              TextFormField(
                decoration:InputDecoration(labelText: "Password"),
                controller: passwordcontroller,
                obscureText: true,
                validator: (value){
                  if(value.isEmpty) return "Password is required";
                }
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      child: Text("Signin"),
                      onPressed: (){
                        _auth.signInWithEmailAndPassword(
                          email: emailcontroller.text,
                          password: passwordcontroller.text,
                        ).then((FirebaseUser user) async {
                          if(user.isEmailVerified){
                            print("Go to home screen");
                          }else{
                            UserManagement().authorizeAccess(context);
                          }
                        });
                      },
                    ),
                  ),
                  FlatButton(
                    child: Text("Register new account"),
                    onPressed: (){
                      
                      Navigator.pushNamed(context, "/register");
                    },
                  )
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}
