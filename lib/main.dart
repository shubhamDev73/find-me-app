import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'UI/Widgets/custom_page_route.dart';
import 'UI/screen/chat/chatLanding.dart';
import 'UI/screen/chat/chatMessage.dart';
import 'UI/screen/home/homePage.dart';
import 'UI/screen/login/loginPage.dart';
import 'UI/screen/onBoardScreen/onBoardingPage.dart';
import 'UI/screen/profileInterestLanding/profileInterestLanding.dart';
import 'UI/screen/profileLandingTrait/profileLandingTrait.dart';
import 'UI/screen/registerPage/registerPage.dart';
import 'UI/screen/profileInterestLanding/addUserInterest.dart';
import 'UI/screen/moodSet/moodSet.dart';
import 'UI/screen/moodHistory/moodHistory.dart';

import 'package:findme/constant.dart';

void main() {
  runApp(Main());
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ThemeColors.accentColor,
      statusBarBrightness: Brightness.dark,
    ));
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primaryColor: ThemeColors.primaryColor,
        accentColor: ThemeColors.accentColor,
        highlightColor: ThemeColors.accentColor,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme().copyWith(
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme().copyWith(
            headline6: Theme.of(context)
                .primaryTextTheme
                .headline6
                .copyWith(color: ThemeColors.primaryColor),
          ),
        ),
        textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyText2: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 14.0))
        ),
        inputDecorationTheme: InputDecorationTheme(
            labelStyle: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 14.0))
        ),
      ),
      initialRoute: '/home',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return PageRouteBuilder(
                pageBuilder: (_, a1, a2) => OnBoardingScreen(),
                settings: settings);
          case '/login':
            return PageRouteBuilder(
                pageBuilder: (_, a1, a2) => LoginScreen(), settings: settings);
          case '/register':
            return PageRouteBuilder(
                pageBuilder: (_, a1, a2) => RegisterScreen(),
                settings: settings);
          case '/home':
            return PageRouteBuilder(
                pageBuilder: (_, a1, a2) => HomeScreen(
                      scaffoldKey: _scaffoldKey,
                    ),
                settings: settings);
          case '/profileLandingTrait':
            return PageRouteBuilder(
                pageBuilder: (_, a1, a2) => ProfileLandingTrait(),
                settings: settings);
          case '/profileInterestLanding':
            return PageRouteBuilder(
                pageBuilder: (_, a1, a2) => ProfileInterestLanding(),
                settings: settings);
          case '/addUserInterest':
            return PageRouteBuilder(
                pageBuilder: (_, a1, a2) => AddUserInterest(),
                settings: settings);
          case '/moodSet':
            return PageRouteBuilder(
                pageBuilder: (_, a1, a2) => MoodSet(), settings: settings);
          case '/moodHistory':
            return PageRouteBuilder(
                pageBuilder: (_, a1, a2) => MoodHistory(), settings: settings);
          case '/chatLanding':
            return PageRouteBuilder(
                pageBuilder: (_, a1, a2) => ChatLandingPage(),
                settings: settings);
          case '/chatMessage':
            return PageRouteBuilder(
                pageBuilder: (_, a1, a2) => ChatMessagePage(),
                settings: settings);
          default:
            return CustomPageRoute.build(
                builder: (_) => OnBoardingScreen(), settings: settings);
        }
      },
    );
  }
}
