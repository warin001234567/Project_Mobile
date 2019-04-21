import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../ui/home.dart';
import '../ui/maindoctor.dart';
import '../ui/homedoctor.dart';

 
class UserManagement {
  authorizeAccess(BuildContext context){
    FirebaseAuth.instance.currentUser().then((user){
      Firestore.instance.collection('/users')
      .where('uid',isEqualTo:user.uid).getDocuments()
      .then((dosc){
        if(dosc.documents[0].exists){
        if(dosc.documents[0].data['role'] == 'Doctor'){
          print(dosc.documents[0].data['uid']);
          Navigator.push(context,MaterialPageRoute(builder: (context) => HomeDoctor(), ),);
        }
        else if(dosc.documents[0].data['role'] == 'Patient'){
          print(dosc.documents[0].data['uid']);
          Navigator.push(context,MaterialPageRoute(builder: (context) => Home(), ),);
        }
        }
      });
    });
  }
}