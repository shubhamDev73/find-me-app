import 'dart:async';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:findme/screens/loading.dart';
import 'package:findme/models/fakeDocument.dart';

class WidgetBuilder<T> {

  final Widget Function(T) widgetCreator;
  const WidgetBuilder(this.widgetCreator);

  Widget Function(BuildContext, AsyncSnapshot<T>) getBuilder ({bool fullPage = true}) {
    return (BuildContext context, AsyncSnapshot<T> snapshot) {
      if(snapshot.hasData) return widgetCreator(snapshot.data);
      else if(snapshot.hasError) return Text("${snapshot.error}");
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

StreamBuilder<QuerySnapshot> createFirebaseStreamWidget(Stream<QuerySnapshot> streamObj, Function widgetCreator, {bool fullPage = true, List<FakeDocument> cacheObj}) {
  return StreamBuilder<QuerySnapshot>(
    stream: streamObj,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if(snapshot.hasData) return widgetCreator(snapshot.data.docs);
      else if(snapshot.hasError) return Text("${snapshot.error}");

      if(cacheObj != null) return widgetCreator(cacheObj);
      return LoadingScreen(fullPage: fullPage);
    },
  );
}

String formatDate ({DateTime timestamp, DateTime endDate}) {
  if(timestamp != null) {
    Duration diff = DateTime.now().difference(timestamp);
    var format = DateFormat(diff.inDays > 0 ? 'dd/MM - hh:mm a' : 'hh:mm a');
    return format.format(timestamp);
  }
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

class DateWidget extends StatefulWidget {

  final DateTime endDate;
  final TextStyle textStyle;
  final String prefix;
  final TextAlign align;

  DateWidget({this.endDate, this.textStyle, this.prefix = '', this.align = TextAlign.left});

  @override
  _DateWidgetState createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {

  Timer timer;

  @override
  void initState () {
    super.initState();
    timer = Timer.periodic(new Duration(minutes: 1), (timer) {setState(() {});});
  }

  @override
  Widget build (BuildContext context) {
    return Text(
      widget.prefix + formatDate(endDate: widget.endDate),
      style: widget.textStyle,
      textAlign: widget.align,
    );
  }

  @override
  void dispose () {
    timer.cancel();
    super.dispose();
  }

}

class Button extends StatelessWidget {

  final double height;
  final double width;
  final String text;
  final Function onTap;

  Button({this.height = 42, this.width = 125, this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
