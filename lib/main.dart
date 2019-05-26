import 'package:flutter/material.dart';
import './ui/login_page.dart';
import './ui/role_page.dart';
import './ui/chat_page.dart';
import './ui/add.dart';
import './ui/home_doctor.dart';
import './ui/main_patient.dart';
import './ui/home_patient.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false, //show bar debug
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(),
      routes:{
       "/" :(context) => LoginScreen(),
       "/register": (context) => RoleScreen(),
       '/homepage': (BuildContext context) => MainPatient(),
       "/show": (context) => Chat(),
       "/add": (context) => Adddoctor(),
       "/chat": (context) => HomeDoctor(),
       "/home": (context) => HomePatient(),
        },
    );
  }
}