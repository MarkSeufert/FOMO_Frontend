import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState
  () => _ProfileScreenState();
}

class _ProfileScreenState 
extends State<ProfileScreen> {

      GoogleSignIn googleSignIn = GoogleSignIn(clientId: "557707736897-b3s5m9qc5c2bdluci63ibugkbibrb5fu.apps.googleusercontent.com");
GoogleSignInAccount account;
GoogleSignInAuthentication auth;
bool gotProfile = false;

@override
  void initState() {
    super.initState();
    getProfile();
      }
      @override
      Widget build(BuildContext context) {
        
        return gotProfile ? Scaffold(
          appBar: AppBar(
            title: Text("User Profile"),
            centerTitle: true,
            actions: [
              IconButton(icon: Icon(Icons.exit_to_app), onPressed: () async {
                googleSignIn.signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },)
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.network(
                account.photoUrl, 
                height: 150,
            ),
            Text(account.displayName),
            Text(account.email),            
            Text(auth.idToken),
            ],
            ),
        ) : LinearProgressIndicator();
      }
    
      void getProfile() async {
        await googleSignIn.signInSilently();
        account = googleSignIn.currentUser;
        auth = await account.authentication;
        setState((){
          gotProfile = true;
        });
      }
}