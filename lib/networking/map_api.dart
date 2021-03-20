import '../model/message.dart';
import '../networking/api_provider.dart';
import 'package:geolocator/geolocator.dart';

import '../util/map_util.dart';
import '../globals.dart' as globals;
import '../model/comment.dart';

class MapAPI {
  static ApiProvider _apiProvider = ApiProvider();

  static Future<List<Message>> getMessages(int radius) async {
    Position position = await MapUtils.determineCurrentPosition();
    Map<String, dynamic> param = {
      "radius": radius.toString(),
      "lat": position.latitude.toString(),
      "long": position.longitude.toString(),
      "expiry": "24",
    };
    final response = await _apiProvider.get("posts", param);
    List<Map> messages = new List<Map>.from(response);
    List<Message> messageList = [];
    messages.forEach((message) {
      messageList.add(Message.fromJson(message));
    });
    return messageList;
  }

  static Future<List<Comment>> getComments(String messageId) async {
    Map<String, dynamic> param = {"postId": messageId};
    final response = await _apiProvider.get("comments", param);
    List<Map> comments = new List<Map>.from(response);
    List<Comment> commentList = [];
    comments.forEach((comment) {
      commentList.add(Comment.fromJson(comment));
    });
    return commentList;
  }

  static Future<Message> postMessage(Message message) async {
    Map<String, String> queryParameters = _getMessagePostQueryParams(message);
    final response =
        await _apiProvider.post("createPost", body: queryParameters);
    Message postedMessage = Message.fromJson(response);
    return postedMessage;
  }

  static Future postMessageWithImage(Message message) async {
    Map<String, String> queryParameters = _getMessagePostQueryParams(message);

    final response = await _apiProvider.postWithImage(
        "createPostWithImage", message.imageFile, queryParameters);

    return response;
  }

  static Future<Comment> postComment(Comment comment) async {
    Map<String, String> queryParameters = _getCommentPostQueryParams(comment);
    final response =
        await _apiProvider.post("addComment", body: queryParameters);
    Comment addedComment = Comment.fromJson(response);
    return addedComment;
  }

  static Map<String, String> _getMessagePostQueryParams(Message message) {
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

  static Map<String, String> _getCommentPostQueryParams(Comment comment) {
    Map<String, String> queryParameters = {
      "message": comment.message,
      "postId": comment.postId
    };
    if (globals.user.id != null) {
      queryParameters["userId"] = globals.user.id;
    }
    return queryParameters;
  }
}
