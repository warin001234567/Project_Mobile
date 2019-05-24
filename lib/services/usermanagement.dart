import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui/home.dart';
import '../ui/maindoctor.dart';
import '../ui/homedoctor.dart';

 
class UserManagement {
  Future authorizeAccess(BuildContext context) async {
    SharedPreferences prefs;
    FirebaseAuth.instance.currentUser().then((user){
      Firestore.instance.collection('/users')
      .where('uid',isEqualTo:user.uid).getDocuments()
      .then((dosc) async {
        if(dosc.documents[0].exists){
        if(dosc.documents[0].data['role'] == 'Doctor'){
          print(dosc.documents[0].data['uid']);
          Navigator.push(context,MaterialPageRoute(builder: (context) => HomeDoctor(), ),);
        }
        else if(dosc.documents[0].data['role'] == 'Patient'){
          print(dosc.documents[0].data['uid']);
          prefs = await SharedPreferences.getInstance();
          await prefs.setString('id', dosc.documents[0].data['uid']);
          await prefs.setString('name', dosc.documents[0].data['Name']);
          print(prefs.getString('id'));
          print(prefs.getString('name'));// Save data in flutter 
          Navigator.push(context,MaterialPageRoute(builder: (context) => Home(), ),);
        }
        }
      });
    });
  }
}