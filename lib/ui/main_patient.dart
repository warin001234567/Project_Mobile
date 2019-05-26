import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPatient extends StatefulWidget {
  @override
  MainPatientState createState() => MainPatientState();
}

class MainPatientState extends State<MainPatient> {
  String id = ''; //idlogin
  String check = '';
  SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    check = prefs.getString('check');
    id = prefs.getString('id') ?? '';

    setState(() {});
  }

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
              onPressed: () async {
                prefs = await SharedPreferences.getInstance();
                prefs.clear();
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
          child: ListView(children: <Widget>[
            StreamBuilder(
            stream: Firestore.instance.collection('Doctor').where('uid', isEqualTo: prefs.getString('check')).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                return ExpansionTile(title: Text("Consult Doctor"),
                 children: <Widget>[
                  ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if(snapshot.data.documents[index].data['uid'] == prefs.getString('check')){
                      return Container(
                        child:
                          buildList(context, snapshot.data.documents[index])
                      );
                    }
                  },
                  itemCount: snapshot.data.documents.length,
                )
                ],);
              }
            },
          ),
          ExpansionTile(title: Text('All doctor'),
          children: <Widget>[
            StreamBuilder(
            stream: Firestore.instance.collection('Doctor').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                      return Container(
                          child: buildList(context, snapshot.data.documents[index])
                      );
                  },
                  itemCount: snapshot.data.documents.length,
                );
              }
            },
          ),
          ],)
          
          ],)
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, DocumentSnapshot document) {
    return Container(
      child: FlatButton(
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
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                    Container(
                      child: Text(
                        'Department: ${document['Department'] ?? 'Not available'}',
                        style: TextStyle(color: Colors.black),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(left: 20.0),
              ),
            ),
          ],
        ),
        onPressed: () {
          _showDialog(document['uid'], document['limit']);
        },
        color: Colors.blueAccent,
        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
  }

  void _showDialog(String peerid, String limit) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Do you want to talk with this doctor?"),
          content: new Text("Please submit your answer"),
          actions: <Widget>[
            FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                print(limit);
                print(int.parse(limit) - 1);
                if (id.hashCode <= peerid.hashCode) {
                  groupchatId = '$id-$peerid';
                } else {
                  groupchatId = '$peerid-$id';
                }
                if ((check == peerid || check == '') && int.parse(limit) >= 0) {
                  if (check == '') {
                    Firestore.instance
                        .collection('Patient')
                        .document(id)
                        .updateData({'check': peerid});
                    Firestore.instance
                        .collection('Doctor')
                        .document(peerid)
                        .updateData(
                            {'limit': (int.parse(limit) - 1).toString()});
                    prefs = await SharedPreferences.getInstance();
                    prefs.setString('check', peerid);
                    check = prefs.getString('check');
                  }
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Chat(
                          groupId: groupchatId, peerId: peerid, userId: id),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context){
                      return AlertDialog(
                    title: Text('Error'),
                    content: Text('You have another consult.'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                    }
                  );
                }
              },
            ),
            FlatButton(
              child: Text('close'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
