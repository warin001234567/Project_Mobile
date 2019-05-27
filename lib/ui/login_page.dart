import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/usermanagement.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth =FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Padding(
        padding: EdgeInsets.only(top: 80),
        
        child: Form(
          key: _formKey,
          child: Column(
              children: <Widget>[
                Text(
                  'SIGN IN',
                  style: TextStyle(
                    fontFamily: 'Quicksand Bold',
                    fontSize: 35,
                    color: Color.fromRGBO(125, 145, 193, 1)
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
                  padding: EdgeInsets.only(top: 20,left: 40,right: 40),

                  child: CustomButton(
                    text: 'Login',
                    height: 40,
                    gradient: LinearGradient(
                    colors: <Color>[Color.fromRGBO(200, 219, 241, 1), Color.fromRGBO(169, 201, 239, 1)],
                    begin: FractionalOffset(0, 0),
                    end: FractionalOffset(0.6, 0),
                    stops: [0.0, 1.0],
                    ),
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                      _auth.signInWithEmailAndPassword(
                          email: emailcontroller.text,
                          password: passwordcontroller.text,
                        ).then((FirebaseUser user) async {
                          if(user.isEmailVerified){
                            print("Go to home screen");
                          }else{
                            UserManagement().authorizeAccess(context);
                          }
                        }).catchError((onError)=>{
                          Scaffold.of(_formKey.currentContext)
	                              .showSnackBar(SnackBar(
	                            content: Text('Invalid username or password'),
	                              )
	                              )
                        });
                      }
                    },
                  )
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
