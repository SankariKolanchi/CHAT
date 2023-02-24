import 'package:chatapp/home_page.dart';
import 'package:chatapp/login_page.dart';
import 'package:chatapp/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthService extends StatelessWidget {
  const AuthService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (_, user){
      if(user.connectionState == ConnectionState.waiting){
        return CircularProgressIndicator();
      }
      else if(user.hasError){
        return LoginPage();
      }
      else if(user.data != null){
        return HomePage();
      }
      else {
       return SignupPage();
      }
    });
  }
}

/// now understand this code or not ?
///
