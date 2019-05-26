
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Chat extends StatefulWidget {
  final String groupId;
  final String peerId;
  final String userId;
  Chat({Key key, this.groupId,this.peerId,this.userId}) : super(key:key);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  int count = 0;
  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  var listmessages;
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
                  
                  buildListMessage(),
                  buildInput(),
                ],
              )
            ],
          ), onWillPop: () {
            Navigator.pop(context);
            Navigator.pop(context);
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
                  hintStyle: TextStyle(color: Colors.red),
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
          .document(widget.groupId)
          .collection(widget.groupId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': widget.userId,
            'idTo': widget.peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
          },
        );
      }); 
      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }
    Widget buildListMessage() {
    return Flexible(
      child: widget.groupId == ''
          ? Center(child: Text("No messages"))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('messages')
                  .document(widget.groupId)
                  .collection(widget.groupId)
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: Text('No Messages'));
                } else {
                  listmessages = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }

    Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == widget.userId) {
      // Right (my message)
      return Row(
        children: <Widget>[
              Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8.0)),
                )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                        child: Text(
                          document['content'],
                          style: TextStyle(color: Colors.white),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    
              ],
            ),

          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

}