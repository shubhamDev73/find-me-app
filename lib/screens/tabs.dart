import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:findme/models/pageTab.dart';
import 'package:findme/constant.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/globals.dart' as globals;

class TabbedScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return createFutureWidget(globals.interests.get(), (data) =>
      createFutureWidget(globals.getUser(), (data) =>
          createFutureWidget(globals.currentTab.get(), (PageTab cachedTab) =>
            Tabs(initTab: cachedTab),
          ),
      ),
    );
  }
}

class Tabs extends StatefulWidget {

  final PageTab initTab;
  Tabs({this.initTab: PageTab.me});

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {

  PageTab _currentTab;

  Widget build(BuildContext context) {
    if(_currentTab == null) _currentTab = widget.initTab;

    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: Scaffold(
        body: Stack(
          children: PageTab.values.map<Widget>((PageTab tab) => Offstage(
            offstage: _currentTab != tab,
            child: tabScreens[tab],
          )).toList(),
        ),
        bottomNavigationBar: SizedBox(
          height: 40,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: PageTab.values.map<BottomNavigationBarItem>((PageTab tab) =>
              tabButton(icon: tabIcon[tab], selected: _currentTab == tab)
            ).toList(),
            currentIndex: PageTab.values.indexOf(_currentTab),
            onTap: (index) {
              PageTab newTab = PageTab.values[index];
              globals.currentTab.set(newTab);
              if(newTab == _currentTab && _currentTab == PageTab.found)
                navigatorKeys[_currentTab].currentState.popUntil(ModalRoute.withName('/'));
              setState(() {
                _currentTab = newTab;
              });
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedFontSize: 0,
            unselectedFontSize: 0,
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem tabButton({String icon, bool selected = false}) {
    return BottomNavigationBarItem(
      label: '',
      icon: Container(
        padding: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: selected ? Radius.circular(0.0) : Radius.circular(6.0),
          ),
          color: selected ? Colors.white : ThemeColors.primaryColor,
          ),
        height: 40,
        width: MediaQuery.of(context).size.width / PageTab.values.length,
        child: SvgPicture.asset(
          icon,
          color: selected ? ThemeColors.primaryColor : Colors.white,
        ),
      ),
    );
  }

}
