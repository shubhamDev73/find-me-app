import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:findme/screens/loading.dart';

class WidgetBuilder<T> {

  final Widget Function(T) widgetCreator;
  const WidgetBuilder(this.widgetCreator);

  Widget Function(BuildContext, AsyncSnapshot<T>) getBuilder ({bool fullPage = true}) {
    return (BuildContext context, AsyncSnapshot<T> snapshot) {
      if (snapshot.hasData) return widgetCreator(snapshot.data);
      else if (snapshot.hasError) return Text("${snapshot.error}");
      return LoadingScreen(fullPage: fullPage);
    };
  }

}

FutureBuilder<T> createFutureWidget<T>(Future<T> futureObj, Widget Function(T) widgetCreator, {bool fullPage = true}) {
  return FutureBuilder<T>(
    future: futureObj,
    builder: WidgetBuilder<T>(widgetCreator).getBuilder(fullPage: fullPage),
  );
}

StreamBuilder<T> createStreamWidget<T>(Stream<T> streamObj, Widget Function(T) widgetCreator, {bool fullPage = true}) {
  return StreamBuilder<T>(
    stream: streamObj,
    builder: WidgetBuilder<T>(widgetCreator).getBuilder(fullPage: fullPage),
  );
}

StreamBuilder<QuerySnapshot> createFirebaseStreamWidget(
  Stream<QuerySnapshot> streamObj,
  Widget Function(List<DocumentSnapshot>) widgetCreator,
  {bool fullPage = true}
) {
  return createStreamWidget(streamObj, (QuerySnapshot query) => widgetCreator(query.docs), fullPage: fullPage);
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
    return num == 0 ? "just now" : "$num $type${num > 1 ? 's' : ''} ago";
  }
  return '';
}
