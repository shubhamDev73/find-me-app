import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:findme/models/pageTab.dart';
import 'package:findme/constant.dart';
import 'package:findme/globals.dart' as globals;
import 'package:findme/events.dart' as events;

class TabbedScreen extends StatefulWidget {

  @override
  _TabbedScreenState createState() => _TabbedScreenState();
}

class _TabbedScreenState extends State<TabbedScreen> {

  PageTab _currentTab = PageTab.found;
  List<PageTab> _tabHistory = List.empty(growable: true);
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if(globals.pageOnTabChange != null) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(globals.pageOnTabChange != null){
      _currentTab = globals.pageOnTabChange!['tab'];
      if(globals.pageOnTabChange!.containsKey('route')){
        navigatorKeys[_currentTab]!.currentState!.popUntil(ModalRoute.withName('/'));
        if(globals.pageOnTabChange!['route'] != '/')
          navigatorKeys[_currentTab]!.currentState!.pushNamed(globals.pageOnTabChange!['route'], arguments: globals.pageOnTabChange!['arguments']);
      }
      globals.pageOnTabChange = null;
    }

    return WillPopScope(
      onWillPop: () async {
        bool canPop = await navigatorKeys[_currentTab]!.currentState!.maybePop();
        if(!canPop){
          if(_tabHistory.isEmpty) return true;
          setState(() {
            _currentTab = _tabHistory.removeLast();
          });
          return false;
        }
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: PageTab.values.map((PageTab tab) => Offstage(
            offstage: _currentTab != tab,
            child: tabScreens[tab],
          )).toList(),
        ),
        resizeToAvoidBottomInset: _currentTab == PageTab.found,
        bottomNavigationBar: SizedBox(
          height: 50,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: PageTab.values.map<BottomNavigationBarItem>((PageTab tab) =>
                tabButton(icon: tabIcon[tab]!, selected: _currentTab == tab)
            ).toList(),
            currentIndex: PageTab.values.indexOf(_currentTab),
            onTap: (index) {
              PageTab newTab = PageTab.values[index];
              if(newTab == _currentTab)
                navigatorKeys[_currentTab]!.currentState!.popUntil(ModalRoute.withName('/'));
              else
                setState(() {
                  _tabHistory.add(_currentTab);
                  _currentTab = newTab;
                });

              events.sendEvent('tabSelect', {"tab": newTab == PageTab.me ? "me" : "found"});
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

  BottomNavigationBarItem tabButton({required String icon, bool selected = false}) {
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
        height: 50,
        width: MediaQuery.of(context).size.width / PageTab.values.length,
        child: SvgPicture.asset(
          icon,
          color: selected ? ThemeColors.primaryColor : Colors.white,
        ),
      ),
    );
  }

}
