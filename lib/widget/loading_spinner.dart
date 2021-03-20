import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Widget loadingDataSpinner(
  BuildContext context, {
  String loadingMessage,
}) {
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
          child: Text(loadingMessage ?? 'Loading data...'),
        )
      ],
    ),
  );
}

Widget smallLoadingDataSpinner(BuildContext context, {String loadingMessage}) {
  return DefaultTextStyle(
    style: Theme.of(context).textTheme.bodyText1,
    textAlign: TextAlign.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          child: CircularProgressIndicator(),
          width: 30,
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(loadingMessage ?? 'Loading data...'),
        )
      ],
    ),
  );
}
