import '../model/message.dart';
import '../networking/api_provider.dart';
import 'package:geolocator/geolocator.dart';

import '../util/map_util.dart';
import '../globals.dart' as globals;

class MapAPI {
  static ApiProvider _apiProvider = ApiProvider();

  static Future<List<Message>> getMessages(int radius) async {
    Position position = await MapUtils.determineCurrentPosition();
    Map<String, dynamic> param = {
      "radius": radius.toString(),
      "lat": position.latitude.toString(),
      "long": position.longitude.toString()
    };
    final response = await _apiProvider.get("posts", param);
    List<Map> messages = new List<Map>.from(response);
    List<Message> messageList = [];
    messages.forEach((message) {
      messageList.add(Message.fromJson(message));
    });
    return messageList;
  }

  static Future<Message> postMessage(Message message) async {
    Map<String, String> queryParameters = _getPostQueryParams(message);
    final response =
        await _apiProvider.post("createPost", body: queryParameters);
    Message postedMessage = Message.fromJson(response);
    return postedMessage;
  }

  static Future postMessageWithImage(Message message) async {
    Map<String, String> queryParameters = _getPostQueryParams(message);

    final response = await _apiProvider.postWithImage(
        "createPostWithImage", message.imageFile, queryParameters);

    return response;
  }

  static Map<String, String> _getPostQueryParams(Message message) {
    Map<String, String> queryParameters = {
      "message": message.body,
      "messageType": message.type.toString(),
      "long": message.position.longitude.toString(),
      "lat": message.position.latitude.toString()
    };
    if (globals.user.id != null) {
      queryParameters["userId"] = globals.user.id;
    }
    return queryParameters;
  }
}
