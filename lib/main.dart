import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:findme/screens/tabs.dart';

import 'package:findme/constant.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Main());
}

class Main extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ThemeColors.accentColor,
      statusBarBrightness: Brightness.dark,
    ));

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
          bodyText2: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 14.0))
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 14.0))
        ),
      ),
      home: TabbedScreen(),
    );
  }
}
