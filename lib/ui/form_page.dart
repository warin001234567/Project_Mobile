import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FormScreen extends StatefulWidget {
  @override
  FormScreenState createState() => new FormScreenState();
}

class FormScreenState extends State<FormScreen> {
    SharedPreferences prefs;

  String id = '';
    @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';

    // Force refresh input
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Profile'),),
        body: new Stack(
      children: <Widget>[
        FutureBuilder(
          future: Firestore.instance.collection('Patient').document(id).get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              return buildForm(context, snapshot.data.data["Daycare"]);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ],
    ));
  }
  Widget buildForm(BuildContext context, String daycare) {
    return Container(
      child: ListView.builder(
        itemCount: int.parse(daycare),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            
          );
        },

      )
    );
    
  }
}
