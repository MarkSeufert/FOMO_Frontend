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
    @required this.messageId,
    @required this.user,
    @required this.type,
    @required this.body,
    this.position,
    this.alpha = 1.0,
    this.visible = true,
  }) : assert(alpha == null || (0.0 <= alpha && alpha <= 1.0));

  final User user;

  final int messageId;

  final MessageType type;

  final String body;

  final LatLng position;

  final double alpha;

  final bool visible;

  Message copyWith({
    MessageType typeParam,
    String bodyParam,
    LatLng positionParam,
    double alphaParam,
    double visibleParam,
  }) {
    return Message(
      messageId: messageId,
      user: user,
      type: typeParam ?? type,
      body: bodyParam ?? body,
      position: positionParam ?? position,
      alpha: alphaParam ?? alpha,
      visible: visibleParam ?? visible,
    );
  }

  Message clone() => copyWith();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('messageId', messageId);
    addIfPresent('user', user);
    addIfPresent('type', type);
    addIfPresent('body', body);
    addIfPresent('position', position?.toString());
    addIfPresent('alpha', alpha);
    addIfPresent('visible', visible);
    return json;
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
        alpha == typedOther.alpha &&
        visible == typedOther.visible;
  }

  @override
  int get hashCode => messageId.hashCode;

  @override
  String toString() {
    return 'Marker{messageId: $messageId, type: $type,'
        'body: $body, position: $position, '
        'alpha: $alpha,visible: $visible}';
  }
}
