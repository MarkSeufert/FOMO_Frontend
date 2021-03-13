import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_config/flutter_config.dart';
import '../util/permission_util.dart';
import '../model/user.dart';
import '../globals.dart' as globals;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignIn googleSignIn =
      GoogleSignIn(clientId: FlutterConfig.get('GOOGLE_SIGN_IN_API_KEY'));

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: Text("Sign In", style: TextStyle(fontSize: 30))),
        SignInButton(
          Buttons.Google,
          onPressed: () async {
            bool isNetworkAvailable =
                await PermissionUtils.checkNetwork(context);
            if (isNetworkAvailable) {
              _googleSignIn();
            }
          },
        ),
        SignInButtonBuilder(
          text: 'Be anonymous user',
          icon: Icons.person,
          backgroundColor: Colors.blueGrey[700],
          onPressed: () {
            _signInAnonymousUser();
          },
        ),
      ],
    ));
  }

  void _googleSignIn() async {
    await googleSignIn.signOut();

    GoogleSignInAccount user = await googleSignIn.signIn();
    if (user == null) {
      print('Sign Imn Failed');
    } else {
      print("Sign In Successful");
      globals.user = User(
          signInType: SignInType.GOOGLE,
          name: user.displayName,
          email: user.email,
          photoUrl: user.photoUrl);
      globals.isLoggedIn = true;
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  void _signInAnonymousUser() async {
    globals.user =
        User(signInType: SignInType.ANONYMOUS, name: "anonymous user");
    globals.isLoggedIn = true;
    Navigator.pushReplacementNamed(context, '/');
  }
}
