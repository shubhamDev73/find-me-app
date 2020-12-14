import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'UI/Widgets/custom_page_route.dart';
import 'UI/screen/home/homePage.dart';
import 'UI/screen/login/loginPage.dart';
import 'UI/screen/onBoardScreen/onBoardingPage.dart';
import 'UI/screen/registerPage/registerPage.dart';
import 'constant.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primaryColor: MyColors().primaryColor,
        accentColor: MyColors().accentColor,
        scaffoldBackgroundColor: Colors.white,
        cursorColor: Colors.white,
        appBarTheme: AppBarTheme().copyWith(
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme().copyWith(
            headline6: Theme.of(context)
                .primaryTextTheme
                .headline6
                .copyWith(color: MyColors().primaryColor),
          ),
        ),
        textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyText2:
                GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 14.0))),
      ),
      initialRoute: '/',
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
                pageBuilder: (_, a1, a2) => HomeScreen(), settings: settings);
          default:
            return CustomPageRoute.build(
                builder: (_) => OnBoardingScreen(), settings: settings);
        }
      },
    );
  }
}
