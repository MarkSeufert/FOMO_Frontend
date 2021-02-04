import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          "557707736897-b3s5m9qc5c2bdluci63ibugkbibrb5fu.apps.googleusercontent.com");

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Sign in", style: TextStyle(fontSize: 30)),
        SignInButton(
          Buttons.Google,
          onPressed: () {
            startSignIn();
          },
        ),
        SignInButtonBuilder(
          text: 'Sign in with Email',
          icon: Icons.email,
          onPressed: () {},
          backgroundColor: Colors.blueGrey[700],
        )
      ],
    ));
  }

  void startSignIn() async {
    await googleSignIn.signOut();
    GoogleSignInAccount user = await googleSignIn.signIn();
    if (user == null) {
      print('Sign In Failed');
    } else {
      Navigator.pushReplacementNamed(context, '/');
    }
  }
}
