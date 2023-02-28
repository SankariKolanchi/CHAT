import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.snapshot});
  final DocumentSnapshot snapshot;
  @override
  State<ChatPage> createState() => _ChatPageState();
}
class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.snapshot['name']), //
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: 2,
              itemBuilder: (BuildContext context,int index){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(""
                    ),
                  ],
                );
              }),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 30,
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: "Type something",
                  suffix: FloatingActionButton(onPressed: (){},child: Icon(Icons.send))
                ),
              ),
            ),
          )
        ],
      ),

    );
  }
}

/// in chat UI there are three things appbar, list of messages, and textfield
///
