import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_page.dart';

class Adddoctor extends StatefulWidget {
  @override
  State<Adddoctor> createState() {
    return AdddoctorState();
  }
}

class AdddoctorState extends State<Adddoctor> {
  String department = '';
  String id;
  String peer;
  String groupchatId;
  ScrollController _controller;
  String message = '';
  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        message = "reach the bottom";
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        message = "reach the top";
      });
    }
  }
  @override
  void initState() {
    _controller = ScrollController();
      _controller.addListener(_scrollListener);
    super.initState();
  }
  Future getdata() async {
    SharedPreferences prefs;
prefs = await SharedPreferences.getInstance();
id = prefs.getString('id') ?? '';
    return id;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Main Patient'),
      ),
      body: WillPopScope(
        child: Stack(
        children: <Widget>[
          Column(
        children: <Widget>[
          Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(
              width: 160.0,
              child: FlatButton(  
                child: Card(
                  child: Wrap(
                    children: <Widget>[

                      Text("dark"),
                    ],
                  ),
                ), onPressed: () {
                  setState(() {
                    print(id);
                   department = 'dark';
                   print(department);
                   
                  });
                },
              ),
            ),
            Container(
              width: 160.0,
              child: FlatButton(  
                child: Card(
                  child: Wrap(
                    children: <Widget>[
                      Text("white"),
                    ],
                  ),
                ), onPressed: () {
                  setState(() {
                   department = 'white';
                   print(department);
                  });
                },
              ),
            ),
            Container(
              width: 160.0,
              child: FlatButton(  
                child: Card(
                  child: Wrap(
                    children: <Widget>[
                      Text("blue"),
                    ],
                  ),
                ), onPressed: () {
                  setState(() {
                   department = 'blue';
                  });
                },
              ),
            ),
            Container(
              width: 160.0,
              child: FlatButton(  
                child: Card(
                  child: Wrap(
                    children: <Widget>[
                      Text("yellow"),
                    ],
                  ),
                ), onPressed: () {
                  setState(() {
                   department = 'blue';
                   print(department);
                  });
                },
              ),
            ),
          ],
        ),
      ),
        Expanded(
          child:Stack(
          children: <Widget>[
            buildDoctor(),
          ],
          )
        )
        ],
      )
        ],
      ), onWillPop: () {},
      )
    );
  }
  Widget buildDoctor(){
    return Container(
              child: StreamBuilder(
                stream: Firestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("print(department);");
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(10.0),
                      controller: _controller,
                      itemBuilder: (context, index) => buildList(context, snapshot.data.documents[index]),
                      itemCount: snapshot.data.documents.length,
                    );
                  }
                },
              ), 
    );
  }
  Widget buildList(BuildContext context, DocumentSnapshot document) {
      return Container(
        child: document['role'] != "Doctor" ? null
        :FlatButton(
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
                    id = document['uid'];
                    someMethod().then((value){
                      if (id.hashCode <= value.hashCode) {
                          groupchatId = '$id-$value';
                        } else {
                          groupchatId = '$value-$id';
                        }
                      Navigator.push(context,MaterialPageRoute(builder: (context) => Chat(groupId: groupchatId, 
                                                                                          peerId: id,
                                                                                          userId: value,
                                                                                          ), ),);
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
  return id;
   }
}