import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {

  final bool fullPage;
  const LoadingScreen({this.fullPage = true});

  @override
  Widget build(BuildContext context) {
    Widget loader = Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );

    return fullPage ? Scaffold(body: loader) : loader;
  }
}
