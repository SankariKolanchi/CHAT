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
  bool showPassword = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: loginKey,
            child: Column(children: [
              SizedBox(height: 50),

              Text(
                "Please signup to continue",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo
                ),
              ),

              Padding(padding: EdgeInsets.all(12.0),
              child: Image.asset('assets/login.jpg',
              height: 250,
              ),
              ),
              //email
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: emailController,
                  validator: validateMail
                  ,
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
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: passwordController, //
                  obscureText: showPassword,
                  validator: validatePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            MaterialPageRoute(
                                builder: (context) => SignupPage()));
                      },
                      child: Text("SignUp"))
                ],
              )
            ]),
          ),
        ));
  }

  String? validateMail (String? mail){
    if(mail==null ||mail.isEmpty){
      return "enter mail";
    }else if(!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(mail)){
       return "enter valid mail";
    }
    else{return null;}
}

  String? validatePassword  (String? password){
    if(password ==null ||password.isEmpty) {
      return "enter password";
    }else if(password.length<6){
      return "password must be greater than 6";
    }else {return null;}

  }

  Future<void> login() async {
    if(!loginKey.currentState!.validate()){return;}


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
      SnackBar snackBar = SnackBar(content: (Text(e.message ?? "OPPs")));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //after login user will navigate to new screen
    }
  }
}