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
  final uid = FirebaseAuth.instance.currentUser!.uid; //
  final messageController = TextEditingController();

  late bool isTyping;
  late String chatId;

  @override
  void initState() {
    chatId = getChatId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.snapshot['name']),
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection("chats")
                  .doc(chatId)
                  .collection("messages")
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("error");
                } else if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        bool isMe = snapshot.data!.docs[index]['uid'] == uid;
                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color:
                                  isMe ? Colors.green[100] : Colors.pink[100],
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(isMe ? 20 : 0),
                                right: Radius.circular(isMe ? 0 : 20.0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data!.docs[index]['message']),
                              ],
                            ),
                          ),
                        );
                      });
                } else {
                  return Text("No message found");
                }
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 80,
                    child: TextFormField(
                      controller: messageController,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Type something",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      sendMessage();
                    },
                    child: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String getChatId() {
    if (uid.hashCode <= widget.snapshot['uid'].hashCode) {
      return '$uid-${widget.snapshot['uid']}';
    } else {
      return '${widget.snapshot['uid']}-$uid';
    }
  }

  void sendMessage() {
    final timeStamp = DateTime.now().millisecondsSinceEpoch;

    if (messageController.text.isNotEmpty) {
      firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .doc(timeStamp.toString())
          .set({
        "uid": uid,
        "message": messageController.text.trim(),
        "time": timeStamp,
      });
      messageController.clear();
    }
  }
}
