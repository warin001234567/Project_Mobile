import 'package:flutter/material.dart';
import './ui/login_page.dart';
import './ui/register_page.dart';
import './ui/homepage.dart';
import './ui/show.dart';
import './ui/add.dart';
import './ui/chatdoctor.dart';
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
       "/register": (context) => RegisterScreen(),
       '/homepage': (BuildContext context) => HomePage(),
       "/show": (context) => Chat(),
       "/add": (context) => Adddoctor(),
       "/chat": (context) => ChatWindow(),
        },
    );
  }
}