import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart' show immutable, required;
import 'user.dart';

enum MessageType {
  regular,
  premium,
  business,
}

@immutable
class Message {
  const Message({
    this.messageId,
    @required this.user,
    @required this.type,
    @required this.body,
    this.position,
    this.visible = true,
    this.createdDate = '',
  });

  final User user;

  final String messageId;

  final MessageType type;

  final String body;

  final LatLng position;

  final bool visible;

  final String createdDate;

  Message copyWith({
    MessageType typeParam,
    String bodyParam,
    LatLng positionParam,
    double visibleParam,
  }) {
    return Message(
      messageId: messageId,
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

    addIfPresent('messageId', messageId);
    addIfPresent('user', user);
    addIfPresent('type', type);
    addIfPresent('body', body);
    addIfPresent('position', position);
    addIfPresent('visible', visible);
    addIfPresent('createdDate', createdDate);
    return json;
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    User user = User.fromJson(json["user"]);
    var lat = json['location']["lat"];
    var lng = json['location']["long"];
    return Message(
      messageId: json['_id'],
      user: user,
      type: MessageType.regular,
      body: json['message'],
      position: LatLng(
          lat is int ? lat.toDouble() : lat, lng is int ? lng.toDouble() : lng),
      visible: json['visible'],
      createdDate: json['date'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Message typedOther = other;
    return messageId == typedOther.messageId &&
        type == typedOther.type &&
        body == typedOther.body &&
        position == typedOther.position &&
        visible == typedOther.visible &&
        createdDate == typedOther.createdDate;
  }

  @override
  int get hashCode => messageId.hashCode;

  @override
  String toString() {
    return 'Marker{messageId: $messageId, type: $type,'
        'body: $body, position: $position, '
        'visible: $visible}';
  }
}
