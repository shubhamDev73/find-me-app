import 'package:findme/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:findme/assets.dart';

import 'package:findme/screens/meTab.dart';
import 'package:findme/screens/foundTab.dart';

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

class TabbedScreen extends StatefulWidget {

  @override
  _TabbedScreenState createState() => _TabbedScreenState();
}

class _TabbedScreenState extends State<TabbedScreen> {

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
            onTap: (index) => setState(() {
              _currentTab = Tab.values[index];
            }),

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
      label: "",
      icon: Container(
        padding: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: selected ? Radius.circular(0.0) : Radius.circular(6.0),
            topRight: selected ? Radius.circular(0.0) : Radius.circular(6.0),
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
