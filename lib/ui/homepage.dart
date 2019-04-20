import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'show.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String id;
  String peer;
  String groupchatId;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Main'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: new Icon(Icons.settings_power),
              onPressed: (){
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator
                          .of(context)
                          .pushReplacementNamed('/');
                    }).catchError((e) {
                      print(e);
                    });
              }
            ),
          ],
        ),
        body: Center(
          child:Container(
              child: StreamBuilder(
                stream: Firestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("No data");
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) => buildList(context, snapshot.data.documents[index]),
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
        child: document['role'] != 'Doctor' ? Text(" ")
        :FlatButton(
          child: Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Nickname: ${document['Name']}',
                          style: TextStyle(color: Colors.black),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          'About me: ${document['Department'] ?? 'Not available'}',
                          style: TextStyle(color: Colors.black),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
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
                    
                    someMethod().then((value){
                      if (id.hashCode <= value.hashCode) {
                          groupchatId = '$id-$value';
                        } else {
                          groupchatId = '$value-$id';
                        }
                        print(groupchatId);
                      Navigator.push(context,MaterialPageRoute(builder: (context) => Chat(groupId: groupchatId, 
                                                                                          peerId: id,
                                                                                          userId: value,), ),);
                    });                                                                    
          },
          color: Colors.blueAccent,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    
  }

  someMethod() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  String id = user.uid;
  print(id);
  return id;
   } 
}