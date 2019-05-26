import 'package:flutter/material.dart';
import 'profile_page.dart';
import './main_doctor.dart';
class HomeDoctor extends StatefulWidget{
  @override
  HomeDoctorState createState() {
    return new HomeDoctorState();
  }
}

class HomeDoctorState extends State<HomeDoctor> {
  int _currentIndex = 0;
  final List<Widget> _home = [
    MainDoctor(),Profile()
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