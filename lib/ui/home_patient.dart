import 'package:flutter/material.dart';
import 'form_page.dart';
import 'main_patient.dart';
import 'profile_page.dart';
class HomePatient extends StatefulWidget{

  @override
  HomePatientState createState() {
    return new HomePatientState();
  }
}

class HomePatientState extends State<HomePatient> {
  int _currentIndex = 0;
  final List<Widget> _home = [
    MainPatient(),FormScreen() ,Profile()
  ];
    bool showDialog = false;



  @override
  Widget build(BuildContext context){
      return Scaffold(
        body:Center(
          child: _home[_currentIndex]
        ),
        bottomNavigationBar:new Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
          ),
        child:BottomNavigationBar(
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              title: Text("Chat"),
              
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.accessibility),
              title: Text("Form")
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.accessibility),
              title: Text("Profile")
            ),
          ],
          onTap: (int index){
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
      );
  }
}