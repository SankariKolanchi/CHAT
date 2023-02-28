import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.snapshot});
  final DocumentSnapshot snapshot;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.snapshot['name']
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: 500,
            child: StreamBuilder<QuerySnapshot>(
                stream: firestore.collection("chats").doc(widget.snapshot['uid']).collection("messages").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("error");
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        // physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              width: 100,
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.all(12),
                              color: Colors.teal[50],
                              child:
                                  Text(snapshot.data!.docs[index]['message']));
                        }
                        //
                        );
                  }
                }),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: message,
                decoration: InputDecoration(
                    fillColor: Colors.teal,
                    filled: true,
                    hintText: "Type something",
                    suffixIcon: FloatingActionButton(
                        onPressed: () {
                          sendMessage();
                        },
                        child: Icon(Icons.send))),
              ),
            ),
          )
        ],
      ),
    );
  }

  void sendMessage() {
    final timeStamp = DateTime.now().millisecondsSinceEpoch;

    if (message.text.isNotEmpty) {
      firestore
          .collection("chats")
          .doc(widget.snapshot['uid'])
          .collection("messages")
          .doc(timeStamp.toString())
          .set({"message": message.text, "time": timeStamp});
      message.clear();

    }
  }
}
