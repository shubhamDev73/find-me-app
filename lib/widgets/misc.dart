import 'package:flutter/material.dart';

FutureBuilder<T> createFutureWidget<T>(Future<T> futureObj, Function widgetCreator) {
  return FutureBuilder<T>(
    future: futureObj,
    builder: (context, snapshot) {
      if (snapshot.hasData) return widgetCreator(snapshot.data);
      else if (snapshot.hasError) return Text("${snapshot.error}");
      return CircularProgressIndicator();
    },
  );
}
