import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Main'),
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
            stream: Firestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) =>
                      buildList(context, snapshot.data.documents[index]),
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
      child: document['role'] != 'Patient'
          ? Container()
          : document['grouppatient'] == document['have']
              ? FlatButton(
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
                                  'Name: ${document['Name']}',
                                  style: TextStyle(color: Colors.black),
                                ),
                                alignment: Alignment.centerLeft,
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                              ),
                              Container(
                                child: Text(
                                  'Department: ${document['Department'] ?? 'Not available'}',
                                  style: TextStyle(color: Colors.black),
                                ),
                                alignment: Alignment.centerLeft,
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              ),
                              Container(
                                child: Text(
                                  'limit: ${document['status'] ?? 'unlimited'}',
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
                      print(groupchatId);
                      print(value);
                      print(id);
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
                )
              : Container(),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
  }

  someMethod() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String id = user.uid;
    return id;
  }
}
