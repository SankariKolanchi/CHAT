import 'package:chatapp/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final signupKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;
  bool showPassword = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: signupKey,
          child: Column(
            children: [
              SizedBox(height: 50),
              Text(
                "Please signup to continue",
                style: TextStyle(
                    color: Colors.pink,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )),
                ),
              ),
              //email
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: emailController,
                  validator: (mail){
                    if(mail == null) {
                      return "enter valid mail";
                  }
                  else{return null;}
                  },
                  autovalidateMode: AutovalidateMode.always,
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
                  controller: passwordController, //
                  obscureText: showPassword,

                  decoration: InputDecoration(
                    labelText: "Password", //
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),

              //confirmPassword
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: showPassword,
                  decoration: InputDecoration(
                      labelText: "Confirm Password",
                      suffix: IconButton(
                        onPressed: (){
                          setState(() {
                            showPassword =!showPassword;
                          });
                        },
                        icon: Icon(
                          showPassword?Icons.visibility:Icons.visibility_off,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            signup();
                          },
                    child: Text(
                      isLoading ? "signing up" : "signup",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account ?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: Text("Login"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



   String? validateMail(String mail){
    if(mail.isEmpty && mail == null){
      return "please enter email";
    }
    else if(RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(mail)){
      return "please enter valid mail";
    }

   }



  Future<void> signup() async {
    try {
      if(!signupKey.currentState!.validate()){
        return ;
      }

      setState(() {
        isLoading = true;
      });

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      user = userCredential.user;
      debugPrint(user!.uid);
      // after signup user will navigate to new screen
      if (user != null) {
        // after signup we save user data in firestore database

        await firestore.collection("users").doc(user!.uid).set({
          "name": nameController.text,
          "email": emailController.text,
        });
      }
      setState(() {
        isLoading = false; //these
      });

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      // display snackbar here
      SnackBar snackBar = SnackBar(content: Text(e.message?? "Something went wrong"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      }
    }
  }
