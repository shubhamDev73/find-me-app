import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

import 'package:findme/models/found.dart';
import 'package:findme/constant.dart';
import 'package:findme/screens/loading.dart';
import 'package:findme/globals.dart' as globals;

class WidgetBuilder<T> {

  final Widget Function(T) widgetCreator;
  const WidgetBuilder(this.widgetCreator);

  Widget Function(BuildContext, AsyncSnapshot<T>) getBuilder (Widget loadingWidget) {
    return (BuildContext context, AsyncSnapshot<T> snapshot) {
      if(snapshot.hasData) return widgetCreator(snapshot.data!);
      else if(snapshot.hasError) return Text("${snapshot.error}");
      return loadingWidget;
    };
  }

}

FutureBuilder<T> createFutureWidget<T>(Future<T> futureObj, Widget Function(T) widgetCreator, {bool fullPage = true, Widget? loadingWidget}) {
  return FutureBuilder<T>(
    future: futureObj,
    builder: WidgetBuilder<T>(widgetCreator).getBuilder(loadingWidget ?? LoadingScreen(fullPage: fullPage)),
  );
}

StreamBuilder<T> createStreamWidget<T>(Stream<T> streamObj, Widget Function(T) widgetCreator, {bool fullPage = true, Widget? loadingWidget}) {
  return StreamBuilder<T>(
    stream: streamObj,
    builder: WidgetBuilder<T>(widgetCreator).getBuilder(loadingWidget ?? LoadingScreen(fullPage: fullPage)),
  );
}

StreamBuilder<QuerySnapshot> createFirebaseStreamWidget(Stream<QuerySnapshot> streamObj, Function widgetCreator, {bool fullPage = true, Widget? waitingWidget}) {
  return StreamBuilder<QuerySnapshot>(
    stream: streamObj,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if(snapshot.hasData) return widgetCreator(snapshot.data?.docs);
      else if(snapshot.hasError) return Text("${snapshot.error}");
      return waitingWidget ?? LoadingScreen(fullPage: fullPage);
    },
  );
}

String formatDate ({DateTime? timestamp, DateTime? endDate}) {
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
  final TextStyle? textStyle;
  final String prefix;
  final TextAlign align;

  DateWidget({required this.endDate, this.textStyle, this.prefix = '', this.align = TextAlign.left});

  @override
  _DateWidgetState createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {

  Timer? timer;

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
    timer?.cancel();
    super.dispose();
  }

}

class Button extends StatelessWidget {

  final String type;
  final double height;
  final double width;
  final String text;
  final double? fontSize;
  final void Function()? onTap;

  Button({this.type = 'default', this.height = 42, this.width = 125, this.text = '', this.fontSize, this.onTap});

  @override
  Widget build(BuildContext context) {
    switch(type){
      case 'default':
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      case 'secondary':
        return Container(
          height: height,
          width: width,
          child: ElevatedButton(
            onPressed: onTap,
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ThemeColors.accentColor,
                fontSize: fontSize,
              ),
            ),
          ),
        );
      case 'back':
        return Column(
          children: [
            SizedBox(height: 50),
            Row(
              children: [
                SizedBox(width: 12),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.arrow_back_ios),
                ),
              ],
            ),
          ],
        );
      default:
        return Container();
    }
  }
}

class Carousel extends StatefulWidget {

  CarouselController? controller;
  final List<dynamic> items;
  final Widget Function(dynamic) widget;
  final Function? onPageChanged;
  final int elementsToDisplay;
  final int initialPage;
  final double gap;
  Carousel({this.controller, required this.items, required this.widget, this.onPageChanged, this.elementsToDisplay = 1, this.initialPage = 0, this.gap = 100});

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {

  int currentIndex = 0;

  @override
  void initState(){
    if(widget.controller == null) widget.controller = new CarouselController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        CarouselSlider(
          carouselController: widget.controller,
          items: widget.items.map((item) => widget.widget(item)).toList(),
          options: CarouselOptions(
            initialPage: widget.initialPage,
            scrollDirection: Axis.horizontal,
            enableInfiniteScroll: true,
            viewportFraction: 1.0 / widget.elementsToDisplay,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
              widget.onPageChanged?.call(index, reason);
            },
          ),
        ),
        Positioned(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: GestureDetector(
                  onTap: () => widget.controller?.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.decelerate,
                  ),
                  child: Container(
                    child: Center(
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: GestureDetector(
                  onTap: () => widget.controller?.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.decelerate,
                  ),
                  child: Container(
                    child: Center(
                      child: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: widget.gap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.items.asMap().map((index, item) => MapEntry(index, Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: currentIndex == index ? null : Border.all(color: Colors.black),
                color: currentIndex == index ? Colors.black : Colors.white,
              ),
            ))).values.toList(),
          ),
        ),
      ],
    );
  }
}

class ThemeScrollbar extends StatelessWidget {

  final Widget child;
  ThemeScrollbar({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: ScrollController(),
      thickness: 5,
      radius: Radius.elliptical(5, 10),
      child: child,
    );
  }

}

class FoundWidget extends StatefulWidget {

  final int id;
  final Widget Function(Found) widget;
  final String string = globals.uuid.v1();
  FoundWidget({required this.id, required this.widget});

  @override
  _FoundWidgetState createState() => _FoundWidgetState();
}

class _FoundWidgetState extends State<FoundWidget> {

  @override
  void initState() {
    globals.onFoundChanged[widget.id]![widget.string] = (Found? found) {if(!mounted) return; setState((){});};
    super.initState();
  }

  @override
  void dispose() {
    globals.onFoundChanged[widget.id]?.remove(widget.string);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return createFutureWidget<Map<int, Found>>(globals.founds.get(), (founds) => widget.widget(founds[widget.id]!));
  }
}
