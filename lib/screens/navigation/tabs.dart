import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:findme/API.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();
    if(Platform.isIOS){
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        saveToken();
      });
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }else{
      saveToken();
    }
  }

  void saveToken () async {
    String fcmToken = await _fcm.getToken();
    POST('notification/token/', jsonEncode({'fcm_token': fcmToken}));
    configureFCM();
  }

  void configureFCM () {
    void Function(Map<String, dynamic>) onNotification = (Map<String, dynamic> message) {
      switch(message['data']['type']){
        case 'Found':
          globals.founds.get(forceNetwork: true);
          break;
        case 'Find':
          globals.finds.get(forceNetwork: true);
          break;
        case 'Request':
          globals.requests.get(forceNetwork: true);
          break;
        case 'Personality':
          globals.meUser.get(forceNetwork: true);
          break;
      }
    };

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        onNotification(message);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
      onLaunch: onNotification,
      onResume: onNotification,
    );
  }

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
