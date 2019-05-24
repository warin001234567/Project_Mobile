import 'package:flutter/material.dart';
import 'package:project_mobile/ui/add.dart';
import 'homepage.dart';
import 'profile.dart';
class Home extends StatefulWidget{
  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _home = [
    Adddoctor(),Profile()
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