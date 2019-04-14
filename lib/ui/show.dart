import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Listuser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("data"),
      ),
      body: StreamBuilder(
      stream: Firestore.instance.collection('New').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return buildList(snapshot.data.documents);
        } else {
          return CircularProgressIndicator();
        }
      },
    ));
  }

  Widget buildList(List<DocumentSnapshot> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: data.elementAt(index).data["Name"] == "pim" ? Text("data")
          : Text("taaa")
        );
      },
    );
  }
}