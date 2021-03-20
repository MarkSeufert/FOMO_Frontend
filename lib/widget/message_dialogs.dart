import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:jiffy/jiffy.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../model/message.dart';

Future<void> showMessageDetails(Message message, BuildContext context) async {
  bool hasPhoto = message.imagePath.isNotEmpty;
  double deviceHeight = MediaQuery.of(context).size.height;

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  "Author: " + message.user.name,
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  "Created on: " +
                      Jiffy(message.createdDate.toString()).yMMMMEEEEdjm,
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(
                  width: 100,
                  height: message.imagePath.isNotEmpty
                      ? deviceHeight * 0.6
                      : deviceHeight * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: hasPhoto
                            ? Image.network(message.imagePath,
                                height: deviceHeight * 0.3)
                            : Text(''),
                      ),
                      AutoSizeText(message.body),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
