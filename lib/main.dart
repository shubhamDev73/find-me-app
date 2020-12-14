import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'activityButtons.dart';
import 'menuButton.dart';
import 'activityTwo.dart';

void main() => {
      runApp(
        MyApp(),
      ),
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xffDFF7F9), // navigation bar color
        statusBarColor: Color(0xffDFF7F9), // status bar color
      ))
    };

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(scaffoldKey: _scaffoldKey),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
    @required GlobalKey<ScaffoldState> scaffoldKey,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200,
                child: Stack(
                  children: [
                    Container(
                      height: 160,
                      color: Color(0xffDFF7F9),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Center(
                              child: Text(
                                "Konichiwa!",
                                style: GoogleFonts.comfortaa(
                                  textStyle: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 10),
                            child: Text(
                              "Did you know the US armys traning bumbelbees to sniff out explosive?",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.comfortaa(
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 35,
                      top: 138,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 8,
                                    color: Colors.grey.shade600,
                                    spreadRadius: 0)
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.verified_user,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 8,
                                    color: Colors.grey.shade600,
                                    spreadRadius: 0)
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.supervised_user_circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 8,
                                    color: Colors.grey.shade600,
                                    spreadRadius: 0)
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.login,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 8,
                                    color: Colors.grey.shade600,
                                    spreadRadius: 0)
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 8,
                                    color: Colors.grey.shade600,
                                    spreadRadius: 0)
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.access_alarm,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 130,
                width: 130,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 8,
                            color: Colors.grey.shade600,
                            spreadRadius: 0,
                          ),
                        ],
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.supervised_user_circle,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 96,
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.black,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "mckme",
                      style: GoogleFonts.comfortaa(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Lorem ipsum dolor sit amet",
                      style: GoogleFonts.comfortaa(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ActivityButton(
                        title: "Drama",
                        function: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ActivityTwo(title: "Drama"),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      ActivityButton(
                        title: "Reading",
                        function: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ActivityTwo(title: "Reading")));
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ActivityButton(
                        title: "Swimming",
                        function: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ActivityTwo(title: "Swimming")));
                        },
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      ActivityButton(
                        title: "Music",
                        function: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ActivityTwo(
                                        title: "Music",
                                      )));
                        },
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 2),
                              blurRadius: 8,
                              color: Colors.grey.shade400,
                              spreadRadius: 0,
                            ),
                          ],
                          color: Colors.white,
                        ),
                        height: 35,
                        width: 95,
                        child: Icon(
                          Icons.add,
                          color: Color(0xff00ADC2),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 5),
                      blurRadius: 10,
                      color: Colors.grey.shade400,
                      spreadRadius: 0,
                    ),
                  ],
                  color: Color(0xffDFF7F9),
                ),
                child: Column(
                  children: [
                    Text(
                      "Some insight about the interest music like theri favorite tracks, or songs they sleep to",
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black),
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.all(8),
                          height: 8,
                          width: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black),
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.all(8),
                          height: 8,
                          width: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black,
                          ),
                          margin: EdgeInsets.all(8),
                          height: 6,
                          width: 6,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black),
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.all(8),
                          height: 8,
                          width: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black),
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.all(8),
                          height: 8,
                          width: 8,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  menuButton(key: "Menu button 1", context: _scaffoldKey),
                  menuButton(key: "Menu button 2", context: _scaffoldKey),
                  menuButton(key: "Menu button 3", context: _scaffoldKey),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
