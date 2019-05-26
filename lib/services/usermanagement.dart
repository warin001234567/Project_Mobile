import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui/home_patient.dart';
import '../ui/home_doctor.dart';


 
class UserManagement {
  Future authorizeAccess(BuildContext context) async {
    SharedPreferences prefs;
    FirebaseAuth.instance.currentUser().then((user){

      Firestore.instance.collection('Doctor')
      .where('uid',isEqualTo:user.uid).getDocuments()
      .then((dosc) async {
        try {
           if(dosc.documents[0].data['role'] == 'Doctor'){
          prefs = await SharedPreferences.getInstance();
          // if(dosc.documents[0].data['isValidated'] == 'true'){
          await prefs.setString('id', dosc.documents[0].data['uid']);
          await prefs.setString('name', dosc.documents[0].data['name']);
          await prefs.setString('role', dosc.documents[0].data['role']);
          await prefs.setString('photoUrl', dosc.documents[0].data['photoUrl']);
        // }
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomeDoctor(), ),);
        }
        } catch (e) {
          Firestore.instance.collection('Patient')
          .where('uid',isEqualTo:user.uid).getDocuments()
          .then((dosc) async {
          prefs = await SharedPreferences.getInstance();
          await prefs.setString('id', dosc.documents[0].data['uid']);
          await prefs.setString('name', dosc.documents[0].data['name']);
          await prefs.setString('check', dosc.documents[0].data['check']);
          await prefs.setString('role', dosc.documents[0].data['role']);
          await prefs.setString('photoUrl', dosc.documents[0].data['photoUrl']);
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomePatient(), ),);
          });
        }
         
        });
          

    });
  }
}