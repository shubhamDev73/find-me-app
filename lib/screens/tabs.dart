import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:findme/assets.dart';
import 'package:findme/screens/meTab.dart';
import 'package:findme/screens/foundTab.dart';
import 'package:findme/constant.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/globals.dart' as globals;

enum Tab { me, found }

final Map<Tab, GlobalKey<NavigatorState>> navigatorKeys = {
  Tab.me: GlobalKey<NavigatorState>(),
  Tab.found: GlobalKey<NavigatorState>(),
};

final Map<Tab, Widget> tabScreens = {
  Tab.me: MeTab(navigatorKey: navigatorKeys[Tab.me]),
  Tab.found: FoundTab(navigatorKey: navigatorKeys[Tab.found]),
};

const Map<Tab, String> tabIcon = {
  Tab.me: Assets.me,
  Tab.found: Assets.found,
};

class TabbedScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return createFutureWidget(globals.interests.get(), (data) =>
      createFutureWidget(globals.getUser(), (data) =>
        Tabs(),
      ),
    );
  }
}

class Tabs extends StatefulWidget {

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {

  Tab _currentTab = Tab.me;

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: Scaffold(
        body: Stack(children: <Widget>[
          Offstage(
            offstage: _currentTab != Tab.me,
            child: tabScreens[Tab.me],
          ),
          Offstage(
            offstage: _currentTab != Tab.found,
            child: tabScreens[Tab.found],
          ),
        ]),
        bottomNavigationBar: SizedBox(
          height: 40,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [
              tabButton(icon: tabIcon[Tab.me], selected: _currentTab == Tab.me),
              tabButton(icon: tabIcon[Tab.found], selected: _currentTab == Tab.found),
            ],
            currentIndex: Tab.values.indexOf(_currentTab),
            onTap: (index) {
              Tab newTab = Tab.values[index];
              if(newTab == _currentTab && _currentTab == Tab.found)
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
        width: MediaQuery.of(context).size.width / Tab.values.length,
        child: SvgPicture.asset(
          icon,
          color: selected ? ThemeColors.primaryColor : Colors.white,
        ),
      ),
    );
  }

}
