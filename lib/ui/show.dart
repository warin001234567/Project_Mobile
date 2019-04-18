import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController textEditingController = new TextEditingController();
  String groupChatId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: WillPopScope(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // buildListMessage(),
                  buildInput(),
                ],
              )
            ],
          ), onWillPop: () {
            Navigator.pushNamed(context, "/homepage");
          }, 
          
      ),
    ); 
  }
      Widget buildInput(){
      return Container(
        child: Row(
          children: <Widget>[
            Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Colors.redAccent, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.white24),
                ),
              ),
            ),
          ),
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Colors.red,
              ),
            ),
            color: Colors.white,
          ),
          ],
        ),
      );
    }
  void onSendMessage(String content, int type) {
  
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': someMethod(),
            // 'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      }); 
    }
  }
  someMethod() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  return user.uid;
   } 
}