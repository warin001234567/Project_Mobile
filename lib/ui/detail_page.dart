
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:shared_preferences/shared_preferences.dart';


class DetailScreen extends StatefulWidget {
  @override
  DetailScreenState createState() => DetailScreenState();
}

class DetailScreenState extends State<DetailScreen> {
  String peerid;
  SharedPreferences prefs;
  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    peerid = prefs.getString('peerid') ?? '';
  }
  @override
  Widget build(BuildContext context) {
    // Force refresh input
    setState(() {
      readLocal();
    });
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Main'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings_power),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.of(context).pushReplacementNamed('/');
                }).catchError((e) {
                  print(e);
                });
              }),
        ],
      ),
      body: Center(
        child: Container(
          child: StreamBuilder(
                  stream: Firestore.instance.collection('Detail').document(peerid).collection(peerid).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.all(10.0),
                        itemBuilder: (context, index) {
                          return Container(
                              child: buildList(
                                  context, snapshot.data.documents[index]));
                        },
                        itemCount: snapshot.data.documents.length,
                      );
                    }
                  },
                ),
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, DocumentSnapshot document) {
      return Container(
        child: Column(children: <Widget>[
          Text(document['eat']),
          Text(document['symptom'])
          ,Text(document['desc']),
        ],),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
    
  }
}
