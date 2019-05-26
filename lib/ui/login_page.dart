import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/usermanagement.dart';

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
      resizeToAvoidBottomPadding: false,
      body: Padding(
        padding: EdgeInsets.only(top: 80),
        
        child: Form(
          child: Column(
              children: <Widget>[
                Text(
                  'SIGN IN',
                  style: TextStyle(
                    fontFamily: 'Quicksand Bold',
                    fontSize: 35,
                    color: Colors.blueGrey
                  ),
                  ),
                Padding(
                  padding: EdgeInsets.only(top: 35,left: 40,right: 40),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Username",
                          labelStyle: TextStyle(
                            fontSize: 11
                          )
                          ),
                        controller: emailcontroller,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value){
                          if(value.isEmpty) return "Email is required";
                        }
                      ),
                      TextFormField(
                        decoration:InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 11
                          )
                          ),
                        controller: passwordcontroller,
                        obscureText: true,
                        validator: (value){
                          if(value.isEmpty) return "Password is required";
                        }
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 23),
                  child: FlatButton(
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Forgot password?",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 11
                        ),
                      ),
                    ),
                    onPressed: (){

                    },
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20,left: 40,right: 40),

                  child: SizedBox(
                    height: 40,
                    child: RawMaterialButton(
                    fillColor: Colors.blueGrey,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                            
                          ),
                        ),
                      ],
                      ),
                    shape: StadiumBorder(),
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
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                        margin: EdgeInsets.only(left: 30.0, right: 20.0),
                        child: Divider(
                          color: Colors.black,
                          height: 36,
                    )),
                      ),
                      Text("or via"),
                      Expanded(
                        child: Container(
                        margin: EdgeInsets.only(left: 20.0, right: 30.0),
                        child: Divider(
                          color: Colors.black,
                          height: 36,
                    )),
                      )
                    ],
                  ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 30, right: 20),
                            child: RawMaterialButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.face),
                                  Padding(padding: EdgeInsets.only(right: 10),),
                                  Text("facebook",
                                  style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 12
                                  ),)
                                ],
                              ),
                              shape: StadiumBorder(
                                side: BorderSide(
                                  width: 0.5
                                )
                              ), onPressed: () {},
                            ),
                          ),
                          ),
                          Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 20, right: 30),
                            child: RawMaterialButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.face),
                                  Padding(padding: EdgeInsets.only(right: 10),),
                                  Text("facebook",
                                  style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 12
                                  ),)
                                ],
                              ),
                              shape: StadiumBorder(
                                side: BorderSide(
                                  width: 0.5
                                )
                              ), onPressed: () {
                                
                              },
                            ),
                          ),
                          )
                      ],
                    ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontSize: 11,
                              ),
                              ),
                              FlatButton(
                                child: Text(
                                  "sing up",
                                  style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontSize: 11,
                                    color: Colors.blue
                                    
                                  ),
                                ),
                                onPressed: (){
                                  Navigator.pushNamed(context, "/register");
                                },
                                )
                          ],
                        ),
                    ),
              ],
          ),
        ),
      )
    );
  }
}
