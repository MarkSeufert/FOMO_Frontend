import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/message.dart';

class InfowindowModel extends ChangeNotifier {
  bool _showInfowindow = false;
  bool _outOfScreen = false;
  Message _message;
  double _leftMargin;
  double _topMargin;
  Marker marker;

  void rebuildInfowindow() {
    notifyListeners();
  }

  void updateMessage(Message message) {
    _message = message;
  }

  void updateVisibility(bool visibility) {
    _showInfowindow = visibility;
  }

  void updateInfowindow(
    BuildContext context,
    GoogleMapController controller,
    LatLng location,
    double infowindowWidth,
    double markerOffset,
  ) async {
    ScreenCoordinate screenCoordinate =
        await controller.getScreenCoordinate(location);
    double devicePixelRatio =
        Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;
    double left = (screenCoordinate.x.toDouble() / devicePixelRatio) -
        (infowindowWidth / 2);
    double top =
        (screenCoordinate.y.toDouble() / devicePixelRatio) - markerOffset;

    if (left < 0 || top < 0) {
      _outOfScreen = true;
    } else {
      _outOfScreen = false;
      _leftMargin = left;
      _topMargin = top;
    }
  }

  bool get showInfowindow =>
      (_showInfowindow == true && _outOfScreen == false) ? true : false;

  double get leftMargin => _leftMargin;
  double get topMargin => _topMargin;
  Message get message => _message;
}
