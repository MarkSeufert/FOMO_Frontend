import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_config/flutter_config.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignIn googleSignIn =
      GoogleSignIn(clientId: FlutterConfig.get('GOOGLE_SIGNIN_API_KEY'));

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
