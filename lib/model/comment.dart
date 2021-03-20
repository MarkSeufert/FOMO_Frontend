import 'package:flutter/material.dart';
import 'package:meta/meta.dart' show immutable, required;
import 'user.dart';

@immutable
class Comment {
  const Comment({
    this.id,
    @required this.postId,
    @required this.user,
    @required this.message,
    this.createdDate,
  });

  final String id;

  final String postId;

  final User user;

  final String message;

  final DateTime createdDate;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value.toString();
      }
    }

    addIfPresent('id', id);
    addIfPresent('user', user);
    addIfPresent('postId', postId);
    addIfPresent('message', message);
    addIfPresent('createdDate', createdDate.toString());
    return json;
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    User user = json["user"] == null
        ? new User(name: "anonymous user")
        : User.fromJson(json["user"]);
    return Comment(
      id: json['_id'],
      user: user,
      postId: json['postId'],
      message: json['message'],
      createdDate: DateTime.parse(json['date']),
    );
  }
}
