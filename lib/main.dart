import 'package:flutter/material.dart';
import 'package:project_mobile/ui/change_profile_patient_page.dart';
import 'package:project_mobile/ui/change_profile_doctor_page.dart';
import 'package:project_mobile/ui/detail_page.dart';
import 'package:project_mobile/ui/profile_page.dart';
import './ui/login_page.dart';
import './ui/role_page.dart';
import './ui/chat_page.dart';
import './ui/add.dart';
import './ui/home_doctor.dart';
import './ui/main_patient.dart';
import './ui/home_patient.dart';
import './ui/walk_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.getInstance().then((prefs) {
    runApp(MyApp(prefs: prefs));
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final SharedPreferences prefs;
  MyApp({this.prefs});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false, //show bar debug
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _handleCurrentScreen(),
      routes: {
        "/login": (context) => LoginScreen(),
        "/register": (context) => RoleScreen(),
        '/homepage': (BuildContext context) => MainPatient(),
        "/show": (context) => Chat(),
        "/add": (context) => Adddoctor(),
        "/chat": (context) => HomeDoctor(),
        "/home": (context) => HomePatient(),
        "/change_patient": (context) => ChangePatientProfile(),
        "/change_doctor": (context) => ChangeDoctorProfile(),
        "/detail": (context) => DetailScreen(),
        '/profile': (context) => Profile(),
      },
    );
  }

  Widget _handleCurrentScreen() {
    bool seen = (prefs.getBool('seen') ?? false);
    if (seen) {
      return new LoginScreen();
    } else {
      return new WalkthroughScreen(
        prefs: prefs,
      );
    }
  }
}
