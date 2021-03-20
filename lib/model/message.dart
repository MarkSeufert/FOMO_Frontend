import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart' show required;
import 'user.dart';
import 'dart:io';
import 'comment.dart';

class Message {
  Message({
    this.id,
    @required this.user,
    @required this.type,
    @required this.body,
    this.position,
    this.visible = true,
    this.createdDate,
    this.imagePath,
    this.imageFile,
  });

  final User user;

  final String id;

  final String type;

  final String body;

  final LatLng position;

  final bool visible;

  final File imageFile;

  final String imagePath;

  final DateTime createdDate;

  Future<List<Comment>> comments;

  Color get color {
    switch (type) {
      case 'regular':
        {
          return Colors.blue;
        }
        break;
      case 'ad':
        {
          return Colors.red[300];
        }
        break;
      default:
        return Colors.blue;
    }
  }

  Message copyWith({
    String typeParam,
    String bodyParam,
    LatLng positionParam,
    double visibleParam,
  }) {
    return Message(
      id: id,
      user: user,
      type: typeParam ?? type,
      body: bodyParam ?? body,
      position: positionParam ?? position,
      visible: visibleParam ?? visible,
    );
  }

  Message clone() => copyWith();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value.toString();
      }
    }

    addIfPresent('id', id);
    addIfPresent('user', user);
    addIfPresent('type', type);
    addIfPresent('body', body);
    addIfPresent('position', position);
    addIfPresent('visible', visible);
    addIfPresent('createdDate', createdDate.toString());
    addIfPresent('image', imagePath);
    return json;
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    User user = json["user"] == null
        ? new User(name: "anonymous user")
        : User.fromJson(json["user"]);
    var lat = json['location']["lat"];
    var lng = json['location']["long"];
    return Message(
      id: json['_id'],
      user: user,
      type: json['messageType'],
      body: json['message'],
      position: LatLng(
          lat is int ? lat.toDouble() : lat, lng is int ? lng.toDouble() : lng),
      visible: json['visible'],
      createdDate: DateTime.parse(json['date']),
      imagePath: json['imageFile'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Message typedOther = other;
    return id == typedOther.id &&
        type == typedOther.type &&
        body == typedOther.body &&
        position == typedOther.position &&
        visible == typedOther.visible &&
        createdDate == typedOther.createdDate;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Marker{id: $id, type: $type,'
        'body: $body, position: $position, '
        'visible: $visible}';
  }
}
