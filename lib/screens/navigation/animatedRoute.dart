import 'package:flutter/material.dart';

PageRouteBuilder animatedRoute (Map<String, Widget> routes, RouteSettings settings) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, anotherAnimation) => routes[settings.name],
    settings: settings,
    transitionDuration: Duration(milliseconds: 2000),
    transitionsBuilder: (context, animation, anotherAnimation, child) {
      animation = CurvedAnimation(curve: Curves.easeIn, parent: animation);
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }
  );
}
