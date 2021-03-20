import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

Widget errorText(String errMessage, BuildContext context) {
  return DefaultTextStyle(
    style: Theme.of(context).textTheme.bodyText1,
    textAlign: TextAlign.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 60,
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text('Error: ' + errMessage),
        )
      ],
    ),
  );
}
