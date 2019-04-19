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
          Navigator.pushNamed(context, "/home");
        }
        else if(dosc.documents[0].data['role'] == 'Patient'){
          Navigator.pushNamed(context, "/home");
        }
        }
      });
    });
  }

  //   Future updateProfilePic(picUrl) async {
  //   var userInfo = new UserUpdateInfo();
  //   userInfo.photoUrl = picUrl;

  //   await FirebaseAuth.instance.updateProfile(userInfo).then((val) {
  //     FirebaseAuth.instance.currentUser().then((user) {
  //       Firestore.instance
  //           .collection('/users')
  //           .where('uid', isEqualTo: user.uid)
  //           .getDocuments()
  //           .then((docs) {
  //         Firestore.instance
  //             .document('/users/${docs.documents[0].documentID}')
  //             .updateData({'photoUrl': picUrl}).then((val) {
  //           print('Updated');
  //         }).catchError((e) {
  //           print(e);
  //         });
  //       }).catchError((e) {
  //         print(e);
  //       });
  //     }).catchError((e) {
  //       print(e);
  //     });
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }
}