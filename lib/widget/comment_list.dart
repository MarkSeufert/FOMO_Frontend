import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../model/comment.dart';
import 'package:jiffy/jiffy.dart';
import '../model/message.dart';

import 'error_text.dart';
import 'loading_spinner.dart';
import '../networking/map_api.dart';
import '../globals.dart' as globals;

class CommentsList extends StatefulWidget {
  final Message post;
  const CommentsList({Key key, this.post}) : super(key: key);
  @override
  State<CommentsList> createState() => CommentsListState();
}

class CommentsListState extends State<CommentsList> {
  Future<List<Comment>> _commentsList;
  var _commentController = TextEditingController();
  String commentMessage = '';

  void updateComments() {
    setState(() {
      _commentsList = MapAPI.getComments(widget.post.id);
    });
  }

  @override
  void initState() {
    super.initState();
    updateComments();
  }

  Future _addComment(Message post, String commentMessage) async {
    final Comment comment = Comment(
      postId: post.id,
      user: globals.user,
      message: commentMessage,
    );
    await MapAPI.postComment(comment);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: FutureBuilder<List<Comment>>(
          future: _commentsList,
          builder:
              (BuildContext context, AsyncSnapshot<List<Comment>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              List<Comment> comments = snapshot.data;
              children = <Widget>[
                ExpansionTile(
                  leading: Icon(Icons.comment),
                  trailing: Text(comments.length.toString()),
                  title: Text("Comments"),
                  children: List<Widget>.generate(
                    comments.length,
                    (int index) => _SingleComment(
                      key: ValueKey("$index"),
                      comment: comments[index],
                    ),
                  ),
                ),
              ];
            } else if (snapshot.hasError) {
              children = <Widget>[
                Center(child: errorText(snapshot.error, context))
              ];
            } else {
              children = <Widget>[
                Center(
                  child: smallLoadingDataSpinner(context,
                      loadingMessage: "Loading comments..."),
                )
              ];
            }
            children.add(TextField(
              controller: _commentController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Comment',
                isDense: true, // Added this
                contentPadding: EdgeInsets.all(8), // Added this
              ),
              style: TextStyle(
                fontSize: 12.0,
                height: 2.0,
              ),
              maxLength: 250,
              maxLines: 1,
              onChanged: (value) {
                setState(() {
                  commentMessage = value;
                });
              },
            ));
            children.add(Container(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  await _addComment(widget.post, commentMessage);
                  _commentController.clear();
                  updateComments();
                },
                child: Text("Add"),
              ),
            ));
            // ]);
            return Column(
              children: children,
            );
          }),
    );
  }
}

class _SingleComment extends StatelessWidget {
  final Comment comment;

  const _SingleComment({Key key, @required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            comment.user.name,
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          Text(comment.message),
          Align(
            alignment: Alignment.centerRight,
            child: Text(Jiffy(comment.createdDate.toString()).yMMMMEEEEdjm,
                style: TextStyle(fontSize: 10, color: Colors.grey)),
          ),
          Divider(
            color: Colors.black45,
          ),
        ],
      ),
    );
  }
}
