import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shared_preferences/shared_preferences.dart';
import './button.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  String id = ''; //idlogin
  SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';

    setState(() {});
  }

  List<String> _departments = <String>[
    "Choose your Time",
    "Morning",
    "Afternoon",
    "Evening",
    "before sleep",
    "did't eat"
  ];
  String _department = "Choose your Time";
  final _formkey = GlobalKey<FormState>();
  TextEditingController desciption = TextEditingController();
  TextEditingController symptom = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Form(
            key: _formkey,
            child: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.only(top: 35, left: 15, right: 15),
              child: Column(
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ]),
                  Padding(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'BAB Form',
                                style: TextStyle(
                                    fontFamily: 'Quicksand Bold',
                                    fontSize: 35,
                                    color: Color.fromRGBO(125, 145, 193, 1)),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: "symptom",
                                    labelStyle: TextStyle(fontSize: 10)),
                                controller: symptom,
                                validator: (value) {
                                  if (value.isEmpty)
                                    return "Please fill symptom";
                                }),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: "When you take Medicine",
                                labelStyle: TextStyle(fontSize: 13),
                              ),
                              isEmpty: _department == '',
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: _department,
                                  isDense: true,
                                  onChanged: (value) {
                                    setState(() {
                                      _department = value;
                                    });
                                  },
                                  items: _departments.map(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        child: Text(value),
                                        value: value,
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: TextFormField(
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: "Desciption",
                                labelStyle: TextStyle(fontSize: 10),
                                border: OutlineInputBorder(),
                              ),
                              controller: desciption,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 35, bottom: 15),
                              child: CustomButton(
                                text: 'Send',
                                height: 40,
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color.fromRGBO(200, 219, 241, 1),
                                    Color.fromRGBO(169, 201, 239, 1)
                                  ],
                                  begin: FractionalOffset(0, 0),
                                  end: FractionalOffset(0.6, 0),
                                  stops: [0.0, 1.0],
                                ),
                                onPressed: () {
                                  Firestore.instance
                                      .collection('Detail')
                                      .document(id)
                                      .collection(id)
                                      .document()
                                      .setData({
                                    'symptom': symptom.text,
                                    'eat': _department,
                                    'desc': desciption.text
                                  });
                                  AlertDialog(
                                    title: Text("Your Form"),
                                    content: Text("Success"),
                                    actions: <Widget>[
                                      FlatButton(
                                          child: new Text("Yes"),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                          })
                                    ],
                                  );
                                },
                              )),
                        ],
                      )),
                ],
              ),
            ))));
  }
}
