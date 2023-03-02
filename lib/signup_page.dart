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
  final signupKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
              SizedBox(height: 60),
              Text(
                "Welcome to chat app",
                style: TextStyle(fontSize: 22),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/signup.jpg",
                  height: 250,
                ),
              ),
              //name
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 25,
                ),
                child: TextFormField(
                  controller: nameController,
                  validator: validateName,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              //email
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25,),
                child: TextFormField(
                  controller: emailController,
                  validator:validateMail,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
                child: TextFormField(
                  controller: passwordController, //
                  obscureText: showPassword,

                  decoration: InputDecoration(
                    labelText: "Password", //
                    suffixIcon: IconButton(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: showPassword,
                  decoration: InputDecoration(
                      labelText: "Confirm Password",
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )),
                ),
              ),
              //button
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
                child: SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              signup();
                            },
                      child: Text(
                        isLoading ? "signing up" : "signup",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                ),
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

  String? validateName(String? name){
    if (name == null || name.isEmpty) {
      return "enter valid name";
    } else {
      return null;
    }
  }

  String? validateMail(String? mail) {
    if (mail == null || mail.isEmpty) {
      return "enter email";
    } else if (RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(mail)) {
      return "enter valid mail";
    }
    else{return null;}
  }

  void validateForm() {
    signupKey.currentState?.save();
    if (!signupKey.currentState!.validate()) {
      return;
    }
  }

  Future<void> signup() async {
    final navigator = Navigator.of(context);
    validateForm();
    try {
      setState(() {
        isLoading = true;
      });

      final userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user = userCredential.user;
      debugPrint(user!.uid);
      // after signup user will navigate to new screen
      await firestore.collection("users").doc(user.uid).set({
        "uid": user.uid,
        "name": nameController.text,
        "email": emailController.text,
      });
      setState(() {
        isLoading = false;
      });

      navigator.pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      setState(() {
        isLoading = false;
      });
      // display snackbar here
      final snackBar = SnackBar(content: Text(e.message ?? "Something went wrong"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
