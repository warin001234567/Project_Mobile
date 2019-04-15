import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Adddoctor extends StatefulWidget {
  @override
  State<Adddoctor> createState() {
    return AdddoctorState();
  }
}

class AdddoctorState extends State<Adddoctor> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _author = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor"),
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _title,
                decoration: InputDecoration(labelText: "Doctor"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill title";
                  }
                },
              ),
              TextFormField(
                controller: _author,
                decoration: InputDecoration(labelText: "Department"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill author";
                  }
                },
              ),
              RaisedButton(
                child: Text("Save"),
                onPressed: () {
                  if (_formkey.currentState.validate()) {
                    // Firestore.instance
                    //     .collection('Doctor')
                    //     .document('Name')
                    //     .setData({
                    //   "Name": _title.text,
                    //   "Department": _author.text,
                    // });
                    Firestore.instance.collection('/New').add({
                    'Name': _title.text,'Department': _author.text
                      });
                    
                  }
                },
              ),
              RaisedButton(
                child: Text("delete"),
                onPressed: () {
                  if (_formkey.currentState.validate()) {
                    Firestore.instance.collection('Doctor').document().delete();
                    
                    print("OKLLLLLLLLLLLLLLL");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}