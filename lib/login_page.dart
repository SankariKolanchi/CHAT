import 'dart:ui';
import 'package:chatapp/home_page.dart';
import 'package:chatapp/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool showPassword =false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: loginKey,
      child: Column(children: [
        SizedBox(height: 50),
        Text(
          "Please signup to continue",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 50),
        //email
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),

        //password
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: passwordController,
            obscureText: showPassword,
            decoration: InputDecoration(
              labelText: "Password",
              suffix: IconButton(onPressed: (){
              setState(() {
                showPassword =!showPassword;
              });
              },
                icon: Icon(showPassword?Icons.visibility:Icons.visibility_off)//next ch
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        // forgot password
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text("Forgot password"),
          ),
        ),
        SizedBox(
          //
          height: 20,
        ),
        SizedBox(
          height: 50,
          width: 300,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    /// here you have to call login funcction :D s
                    login();
                  },
            child: Text(isLoading ? "logging" : "Login"),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account ?"),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupPage()));
                },
                child: Text("SignUp"))
          ],
        )
      ]),
    ));
  } //

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      user = userCredential.user;
      if (user != null) {
        setState(() {
          isLoading = false;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
    } //
    //after login user will navigate to new screen
  }
}
