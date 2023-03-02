import 'package:chatapp/chat_page.dart';
import 'package:chatapp/profile_page.dart';
import 'package:chatapp/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // initialize firestore
  final firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),


      
      body: StreamBuilder(
          stream: firestore.collection('users').snapshots(),
          builder: (_, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            else if(snapshot.hasError){
              return Text("Error");
            }
            else if(snapshot.data != null){
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (_, index){
                    return
            uid == snapshot.data!.docs[index]['uid']?
                SizedBox():
                      ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatPage(snapshot: snapshot.data!.docs[index]
                        )));
                      },
                      leading: CircleAvatar(
                        child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfilePage(snapshot: snapshot.data!.docs[index]
                              )));
                            },
                            child: Text((snapshot.data!.docs[index]['name'][0]).toString().toUpperCase())),
                      ),
                      title: Text(snapshot.data!.docs[index]['name']
                      ),
                        subtitle: Text(snapshot.data!.docs[index]['email']),
                    );
                  });
            }
            else{
              return Text("no data found");
            }
      }),
      
      floatingActionButton: FloatingActionButton(onPressed: (){
        logout();
      }, child: Icon(Icons.logout),),
    );
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignupPage()));

  }


  /*Future<void> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

   setState(() {
     deviceName = androidInfo.model;
   });
  }
*/
}





