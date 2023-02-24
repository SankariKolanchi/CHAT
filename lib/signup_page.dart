import 'package:chatapp/login_page.dart';
import 'package:chatapp/profile_page.dart';
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
  final  signupKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryController =TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController =TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: signupKey,
          child: Column(
            children: [
              SizedBox(height: 50),
              Text("Please signup to continue", style: TextStyle(color: Colors.pink,fontSize: 18,fontWeight: FontWeight.bold),),
              SizedBox(height: 50),
              //name
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )
                  ),
                ),
              ),
              //email
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    )
                  ),
                ),
              ),




              //password
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )
                  ),
                ),
              ),

              //confirmPassword
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                      labelText: "Confirm Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )
                  ),
                ),
              ),
              SizedBox(height: 50,),
              SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    signup();
                  },
                  child :Text("Login", style: TextStyle(fontSize:18,fontWeight: FontWeight.bold),)
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(children: [
                Text("Already have an account ?"),
TextButton(onPressed: (){

  Navigator.push(context,MaterialPageRoute(builder: (context)=> const LoginPage()));


}, child: Text("Login")
)
              ],),

            ],
          ),
        ),
      ),

    );
  }


  Future<void> signup() async{

    UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text,);
    user = userCredential.user;
    debugPrint(user!.uid);
    // after signup user will navigate to new screen
    if(user != null){
      // after signup we save user data in firestore database



      await firestore.collection("users").doc(user!.uid).set({
        "name": nameController.text,
        "email": emailController.text,
      });

      Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomePage()));
    }

  }
}
