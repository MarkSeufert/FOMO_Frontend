import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:clippy_flutter/clippy_flutter.dart' hide Message;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_config/flutter_config.dart';

import '../model/user.dart';
import '../model/message.dart';
import '../util/map_util.dart';
import '../util/permission_util.dart';
import '../globals.dart' as globals;
import 'package:auto_size_text/auto_size_text.dart';

import 'post_message.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  GoogleSignIn googleSignIn =
      GoogleSignIn(clientId: FlutterConfig.get('GOOGLE_SIGNIN_API_KEY'));

  Completer<GoogleMapController> _controller = Completer();
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  Set<Marker> _markers = {}; // Will be removed once api calls implemented
  static List<Message> messageList;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  @override
  void initState() {
    messageList = [
      Message(
          messageId: 1,
          user: globals.user,
          type: MessageType.regular,
          body: "test body",
          position: LatLng(36.333867, 127.395177)),
      Message(
          messageId: 2,
          user: globals.user,
          type: MessageType.regular,
          body: "test body2",
          position: LatLng(36.333867, 127.405177)),
    ];
    super.initState();
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  void _onMenuTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        break;
      case 1:
        bool hasAllPermissions =
            await PermissionUtils.requestAllPermissions(context);
        if (hasAllPermissions) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostMessagePage()),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _initMarkers(context);
    return new Scaffold(
      appBar: AppBar(
        title: Text("FOMOGO"),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Align(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: globals.user.photoUrl != null
                            ? Image.network(
                                globals.user.photoUrl,
                                height: 50,
                              )
                            : Icon(Icons.account_box_rounded)),
                    Text(globals.user.name ?? '',
                        style: TextStyle(fontSize: 20, color: Colors.white))
                  ],
                )),
          ),
        ],
      ),
      drawer: Drawer(
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
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
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
                            _showSignOutDialog();
                          },
                        ),
                      ],
                    )))),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove();
            },
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);
              _customInfoWindowController.googleMapController = controller;
              bool hasAllPermission =
                  await PermissionUtils.requestAllPermissions(context);
              if (hasAllPermission) {
                print("going to current loc");
                await _goToCurrentLocation();
              }
            },
            markers: _markers,
            myLocationEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 75,
            width: 150,
            offset: 50,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Post',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Friends',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onMenuTapped,
      ),
    );
  }

  void _initMarkers(BuildContext context) {
    messageList.forEach((message) {
      _markers.add(
        Marker(
          markerId: MarkerId("marker_" + message.messageId.toString()),
          position: message.position,
          onTap: () {
            _customInfoWindowController.addInfoWindow(
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: RaisedButton(
                        color: Colors.blue,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              AutoSizeText(
                                message.body,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: FractionalOffset.bottomRight,
                                  child: Text(
                                    "created by: " + message.user.name,
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () {
                          _showMessageDetails(message);
                        },
                      ),
                    ),
                  ),
                  Triangle.isosceles(
                    edge: Edge.BOTTOM,
                    child: Container(
                      color: Colors.blue,
                      width: 20.0,
                      height: 10.0,
                    ),
                  ),
                ],
              ),
              message.position,
            );
          },
        ),
      );
    });
  }

  Future<void> _goToCurrentLocation() async {
    bool hasLocationPermissions =
        await PermissionUtils.requestLocationPermissions(context);
    if (hasLocationPermissions) {
      Position currentPosition = await MapUtils.determineCurrentPosition();
      CameraPosition _cameraPos = CameraPosition(
          target: LatLng(currentPosition.latitude, currentPosition.longitude),
          zoom: 19.151926040649414);
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPos));
    } else {
      await PermissionUtils.showLocationServiceDialog(context);
    }
  }

  Future<void> _showSignOutDialog() async {
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

  Future<void> _showMessageDetails(Message message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "Author: " + message.user.name,
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          AutoSizeText(message.body),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
