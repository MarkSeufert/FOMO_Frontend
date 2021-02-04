import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_config/flutter_config.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GoogleSignIn googleSignIn =
      GoogleSignIn(clientId: FlutterConfig.get('GOOGLE_SIGNIN_API_KEY'));

  // User user = User();
  @override
  void initState() {
    super.initState();
    checkSigninStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Welcome", style: TextStyle(fontSize: 30)),
        CircularProgressIndicator()
      ],
    ));
  }

  void checkSigninStatus() async {
    await Future.delayed(Duration(seconds: 2));
    bool isSignedIn = await googleSignIn.isSignedIn();
    bool passSignIn = true;

    if (isSignedIn || passSignIn) {
      print("user signed in");
      Navigator.pushReplacementNamed(context, '/map');
    } else {
      print("user not signed in");
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
