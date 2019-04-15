import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
 
import 'package:flutter/widgets.dart';
 
class UserManagement {
  storeNewUserD(user, context) {
    Firestore.instance.collection('/users').add({
      'email': user.email,
      'uid': user.uid,
      'role': "Doctor"
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/chat');
    }).catchError((e) {
      print(e);
    });
  }

    storeNewUserP(user, context) {
    Firestore.instance.collection('/users').add({
      'email': user.email,
      'uid': user.uid,
      'role': "Patient"
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/homepage');
    }).catchError((e) {
      print(e);
    });
  }

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