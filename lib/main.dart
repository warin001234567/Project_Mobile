import 'package:flutter/material.dart';
import './ui/login_page.dart';
import './ui/register_page.dart';

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
        },
    );
  }
}