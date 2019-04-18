import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
 
import 'package:flutter/widgets.dart';
 
class UserManagement {
  authorizeAccess(BuildContext context){
    FirebaseAuth.instance.currentUser().then((user){
      Firestore.instance.collection('/users')
      .where('uid',isEqualTo:user.uid).getDocuments()
      .then((dosc){
        if(dosc.documents[0].exists){
        if(dosc.documents[0].data['role'] == 'Doctor'){
          Navigator.pushNamed(context, "/chat");
        }
        else if(dosc.documents[0].data['role'] == 'Patient'){
          Navigator.pushNamed(context, "/homepage");
        }
        }
      });
    });
  }

}