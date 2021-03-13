import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity/connectivity.dart';

class PermissionUtils {

  static Future<bool> isNetworkAvailable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static Future<bool> checkNetwork(BuildContext context) async {
    var isNetworkAvailable = await PermissionUtils.isNetworkAvailable();
    if (!isNetworkAvailable) {
      PermissionUtils.showNetworkWarningDialog(context);
      return false;
    }
    return true;
  }

  static Future<void> showNetworkWarningDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Network Unavailable'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please check your network settings.'),
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
  
  static Future<bool> requestLocationPermissions(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      await showLocationServiceDialog(context);
      return false;
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        await Geolocator.openAppSettings();
        return false;
      }
    }
    return true;
  }

  static Future<bool> isLocationServiceAvailable() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled || 
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      return false;
    }
    return true;
  }

  static Future<bool> requestAllPermissions(BuildContext context) async {
    await checkNetwork(context);
    await requestLocationPermissions(context);
    bool hasNetworkPermission = await PermissionUtils.isNetworkAvailable();
    bool hasLocationPermission = await isLocationServiceAvailable();
    if (hasNetworkPermission && hasLocationPermission) {
      return true;
    }
    return false;
  }

  static Future<void> showLocationServiceDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Service'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This app needs location access.'),
                Text('Please enable location service.'),
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
