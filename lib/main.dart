import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'UI/screen/leadingPage/landingPage.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xffDFF7F9), // navigation bar color
    statusBarColor: Color(0xffDFF7F9), // status bar color
  ));
  runApp(Main());
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        body: LandingPage(scaffoldKey: _scaffoldKey),
      ),
    );
  }
}
