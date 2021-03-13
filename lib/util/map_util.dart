import 'dart:async';

// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_map/flutter_map.dart';
// // import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
// import 'package:latlong/latlong.dart';

// import 'package:flutter_application_1/message.dart';

class MapUtils {
  static bool ddd = true;
  static void testFn() {
    print('test');
  }

  static Future<Position> determineCurrentPosition() async {
    bool hasPermission = await requestPermissions();
    if (!hasPermission) {
      return Future.error('Location permissions are denied.');
    }
    return await Geolocator.getCurrentPosition();
  }

  // static Future<Position> _determineCurrentPosition() =>
  //     Geolocator.getCurrentPosition();

  static Future<bool> requestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // await _showMyDialog();
        await Geolocator.openAppSettings();
        return false;
      }
    }
    return true;
  }

  // static void moveToCurrentLocation() async {
  //   Position currentPosition = await MapUtils.determineCurrentPosition();
  //   LatLng destLocation =
  //       LatLng(currentPosition.latitude, currentPosition.longitude);
  //   double destZoom = 10;
  //   MapController _mapController = MapController();
  //   // Create some tweens. These serve to split up the transition from one location to another.
  //   // In our case, we want to split the transition be<tween> our current map center and the destination.
  //   final _latTween = Tween<double>(
  //       begin: _mapController.center.latitude, end: destLocation.latitude);
  //   final _lngTween = Tween<double>(
  //       begin: _mapController.center.longitude, end: destLocation.longitude);
  //   final _zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);

  //   // Create a animation controller that has a duration and a TickerProvider.
  //   var controller = AnimationController(
  //       duration: const Duration(milliseconds: 500), vsync: vsync);
  //   // The animation determines what path the animation will take. You can try different Curves values, although I found
  //   // fastOutSlowIn to be my favorite.
  //   Animation<double> animation =
  //       CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

  //   controller.addListener(() {
  //     _mapController.move(
  //         LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
  //         _zoomTween.evaluate(animation));
  //   });

  //   // animation.addStatusListener((status) {
  //   //   if (status == AnimationStatus.completed) {
  //   //     if (initialStateOfupdateMapLocationOnPositionChange) {
  //   //       setState(() {
  //   //         widget.options.updateMapLocationOnPositionChange = true;
  //   //       });
  //   //     }

  //   //     controller.dispose();
  //   //   } else if (status == AnimationStatus.dismissed) {
  //   //     if (initialStateOfupdateMapLocationOnPositionChange) {
  //   //       setState(() {
  //   //         widget.options.updateMapLocationOnPositionChange = true;
  //   //       });
  //   //     }
  //   //     controller.dispose();
  //   //   }
  //   // });
  //   controller.forward();
  // }

  // Future<void> _showMyDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('AlertDialog Title'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text('This is a demo alert dialog.'),
  //               Text('Would you like to approve of this message?'),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('Approve'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
