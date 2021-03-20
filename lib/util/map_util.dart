import 'dart:async';
import 'package:geolocator/geolocator.dart';

class MapUtils {
  static Future<Position> determineCurrentPosition() async {
    bool hasPermission = await requestPermissions();
    if (!hasPermission) {
      return Future.error('Location permissions are denied.');
    }
    return await Geolocator.getCurrentPosition();
  }

  static Future<bool> requestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled ||
        permission == LocationPermission.deniedForever ||
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
}
