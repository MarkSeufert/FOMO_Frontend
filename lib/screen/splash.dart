import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_config/flutter_config.dart';
import '../globals.dart' as globals;
import '../model/user.dart';
import '../networking/user_api.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GoogleSignIn googleSignIn =
      GoogleSignIn(clientId: FlutterConfig.get('GOOGLE_SIGNIN_API_KEY'));

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
        Text("Welcome!", style: TextStyle(fontSize: 30)),
        CircularProgressIndicator()
      ],
    ));
  }

  void checkSigninStatus() async {
    await Future.delayed(Duration(seconds: 2));
    bool isGoogleSignedIn = await googleSignIn.isSignedIn();
    if (isGoogleSignedIn || globals.isLoggedIn) {
      if (globals.user == null && isGoogleSignedIn) {
        await googleSignIn.signInSilently();
        GoogleSignInAccount account = googleSignIn.currentUser;
        User user = await UserAPI.getUser(account.email, SignInType.GOOGLE);
        globals.user = user;
        globals.isLoggedIn = true;
      }
      Navigator.pushReplacementNamed(context, '/map');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
