import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Widget loadingDataSpinner(BuildContext context) {
  return DefaultTextStyle(
    style: Theme.of(context).textTheme.headline6,
    textAlign: TextAlign.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          child: CircularProgressIndicator(),
          width: 60,
          height: 60,
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text('Loading data...'),
        )
      ],
    ),
  );
}
