import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

String formatDate ({Timestamp timestamp, DateTime endDate}) {
  var format = DateFormat('yyyy-MM-dd H:m');

  if(timestamp != null)
    return format.format(timestamp.toDate());
  if(endDate != null){
    Duration diff = DateTime.now().difference(endDate);
    int num = diff.inMinutes;
    String type = 'min';
    if(diff.inDays > 0) {
      num = diff.inDays;
      type = 'day';
    }else if(diff.inHours > 0) {
      num = diff.inHours;
      type = 'hour';
    }
    return "$num $type${num > 1 ? 's' : ''} ago";
  }
}
