import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'button.dart';
import 'chat_page.dart';

class MainDoctor extends StatefulWidget {
  @override
  _MainDoctorState createState() => _MainDoctorState();
}

class _MainDoctorState extends State<MainDoctor> {
  String id;
  String peer;
  String groupchatId;
  String checked;
  String uid;
  SharedPreferences prefs;
  
  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('id') ?? '';
  }
  @override
  Widget build(BuildContext context) {
    // Force refresh input
    setState(() {
      readLocal();
    });
    return new Scaffold(
      appBar:  AppBar(
        automaticallyImplyLeading: false,
        title:  Text('Main'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: new Icon(Icons.settings_power),
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
                  stream: Firestore.instance.collection('Patient').snapshots(),
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
    print(uid);
    print(document.data);
    if(document.data['check'] == uid){
      return Container(
              child: Column(
                children: <Widget>[
                  FlatButton(
                      child: Row(
                        children: <Widget>[
                          Material(
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.0,
                                    ),
                                    width: 50.0,
                                    height: 50.0,
                                    padding: EdgeInsets.all(15.0),
                                  ),
                              imageUrl: document['photoUrl'],
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                          Flexible(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'Name: ${document['name']}',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    margin:
                                        EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                                  ),
                                  Container(
                                    child: Text(
                                      'Symptom: ${document['symptom'] ?? 'Not available'}',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    margin:
                                        EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                  )
                                ],
                              ),
                              margin: EdgeInsets.only(left: 20.0),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        id = document['uid'];
                        someMethod().then((value) {
                          if (id.hashCode <= value.hashCode) {
                            groupchatId = '$id-$value';
                          } else {
                            groupchatId = '$value-$id';
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Chat(
                                    groupId: groupchatId,
                                    peerId: id,
                                    userId: value,
                                  ),
                            ),
                          );
                        });
                      },
                      color: Colors.blueAccent,
                      padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                                        SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        CustomButton(
                          gradient: LinearGradient(
                            colors: <Color>[Color.fromRGBO(200, 219, 241, 1), Color.fromRGBO(169, 201, 239, 1)],
                            begin: FractionalOffset(0, 0),
                            end: FractionalOffset(0.6, 0),
                            stops: [0.0, 1.0],
                          ),
                          width: 100,
                          text: "Detail form",
                          onPressed: () async {
                            prefs = await SharedPreferences.getInstance();
                            prefs.setString('peerid', document['uid']);
                            Navigator.pushNamed(context, "/detail");
                        },),
                      ],
                    )
                ],
              ),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
    }
    
  }

  someMethod() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String id = user.uid;
    return id;
  }
}
