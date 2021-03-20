import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_config/flutter_config.dart';

import '../model/user.dart';

import '../globals.dart' as globals;

Widget mapDrawer(BuildContext context) {
  return Drawer(
    child: Column(
      children: <Widget>[
        Expanded(
            child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
                height: 120.0,
                child: DrawerHeader(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(globals.user.name ?? '',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                )),
            ListTile(
              title: Text('close'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        )),
        Container(
            child: Align(
                alignment: FractionalOffset.bottomRight,
                child: Container(
                    child: Column(
                  children: <Widget>[
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Log out'),
                      onTap: () async {
                        _showSignOutDialog(context);
                      },
                    ),
                  ],
                )))),
      ],
    ),
  );
}

Future<void> _showSignOutDialog(BuildContext context) async {
  GoogleSignIn googleSignIn =
      GoogleSignIn(clientId: FlutterConfig.get('GOOGLE_SIGNIN_API_KEY'));
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Log out'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you you want to log out?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('YES'),
            onPressed: () async {
              Navigator.of(context).pop();
              if (globals.user.signInType == SignInType.GOOGLE) {
                await googleSignIn.signOut();
              }
              globals.user = null;
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          TextButton(
            child: Text('NO'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
