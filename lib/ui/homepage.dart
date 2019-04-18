import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'show.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String peerId;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Main'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            child: StreamBuilder(
              stream: Firestore.instance.collection('/users').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(!snapshot.hasData){
                  return CircularProgressIndicator();
                }else{
                  return buildList(snapshot.data.documents);
                }
              },
            )
            ),
          ),
        );
  }
  Widget buildList(List<DocumentSnapshot> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Column(
            children: <Widget>[
                FlatButton(
                  child: ListTile(
                    title: data.elementAt(index).data['role'] == "Doctor" ? Text(data.elementAt(index).data['Name']):Text("None"),
                    subtitle: data.elementAt(index).data['role'] == "Doctor" ? Text(data.elementAt(index).data['Department']):Text("None"),
                    ),
                  onPressed: (){
                                Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(
                        )));
                    print(data.elementAt(index).data['uid'].hashCode);
                    someMethod();               
                },
              ),
                OutlineButton(
                  borderSide: BorderSide(
                      color: Colors.red, style: BorderStyle.solid, width: 3.0),
                  child: Text('Logout'),
                  onPressed: () {
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator
                          .of(context)
                          .pushReplacementNamed('/');
                    }).catchError((e) {
                      print(e);
                    });
                  },
                ),
            ],
            
          ),

        );
      },
    );
  }
  someMethod() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  print(user.uid.hashCode);
   } 
}