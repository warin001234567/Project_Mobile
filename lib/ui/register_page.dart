import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formkey =GlobalKey<FormState>();
  TextEditingController emailcontrol =TextEditingController();
  TextEditingController passcontrol =TextEditingController();
  TextEditingController passconfcontrol =TextEditingController();
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
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                controller: emailcontrol,
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  if(value.isEmpty) return "Email is required";
                }
              ),
              TextFormField(
                decoration:InputDecoration(labelText: "Password"),
                obscureText: true,
                controller: passcontrol,
                validator: (value){
                  if(value.isEmpty) return "Password is required";
                  else if(value.length < 8) return "Password much more than 8";
                }
              ),
              TextFormField(
                decoration:InputDecoration(labelText: "Password"),
                obscureText: true,
                controller: passconfcontrol,
                validator: (value){
                  if(value.isEmpty) return "Password is required";
                  else if(passcontrol.text != passconfcontrol.text) return "Password Not Same";
                }
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      child: Text("Register"),
                      onPressed: (){
                        if(_formkey.currentState.validate()){
                          auth
                          .createUserWithEmailAndPassword(
                            email: emailcontrol.text,
                            password: passcontrol.text)
                            .then((FirebaseUser user){
                              user.sendEmailVerification();
                              print("--------return from firebase $user.email");
                            });
                          // Navigator.pushNamed(context, "/");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}