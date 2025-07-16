//import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_notes/screens/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? name;
  String? pictureURL;
  String? email, buttonMessage;
  bool isVisibleSignIn= true, isVisibleSignOut= false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account information"),
      ),
      body: Container(
        color: Colors.blue[200],
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: pictureURL != null
                    ?  Image.network(
                      pictureURL!,
                      height: 75,
                      width: 75,
                    )
                    : Image.asset(
                        "assets/images/profile.png",
                        height: 75,
                        width: 75,
                      ),
                  ),
              ],
              ),
              Text(name?? "Not signed in",
                style: const TextStyle(
                  fontSize: 25
                )
              ),
              Text(email ?? "Not signed in"),
              const SizedBox(height: 20),
                Visibility(
                  visible: isVisibleSignIn,
                  child: ElevatedButton(onPressed: () async{
                    bool isLogged= await login();
                    if(isLogged){
                      setState(() {
                      final user= FirebaseAuth.instance.currentUser;
                  
                      pictureURL= user?.photoURL;
                      name= user?.displayName;
                      email= user?.email;
                      isVisibleSignIn= false;
                      isVisibleSignOut= true;
                      });
                    }
                    
                  },
                    child: Text("Sign in to Google"),
                  ),
                ),
                Visibility(
                  visible: isVisibleSignOut,
                  child: ElevatedButton(onPressed: () async{
                    logout();
                    setState(() {
                      pictureURL= null;
                      name= "Not signed in";
                      email= "Not signed in";
                      isVisibleSignOut= false;
                      isVisibleSignIn= true;
                    });
                  },
                    child: Text("Sign out"),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> login()async{
  try {
    final user = await GoogleSignIn().signIn();
    if (user == null) {
      print("Google sign-in aborted by user.");
      return false;
    }
    GoogleSignInAuthentication userAuth = await user.authentication;

    var credential = GoogleAuthProvider.credential(
      idToken: userAuth.idToken,
      accessToken: userAuth.accessToken,
    );
    
    await FirebaseAuth.instance.signInWithCredential(credential);
    print("Signed in successfully!");

    return FirebaseAuth.instance.currentUser != null;
  } catch (e, stack) {
    print("Login error: $e");
    print(stack);
    return false;
  }
}

Future<void> logout() async{
  try{
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  } catch(e, stack){
    print("Logout error: $e");
    print(stack);
    return;
  }
  
}