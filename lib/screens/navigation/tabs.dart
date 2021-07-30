import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:findme/models/pageTab.dart';
import 'package:findme/models/found.dart';
import 'package:findme/constant.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/globals.dart' as globals;

class TabbedScreen extends StatefulWidget {

  final PageTab initTab;
  TabbedScreen({this.initTab: PageTab.me});

  @override
  _TabbedScreenState createState() => _TabbedScreenState();
}

class _TabbedScreenState extends State<TabbedScreen> {

  PageTab _currentTab;
  List<PageTab> _tabHistory;

  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();
    _tabHistory = new List<PageTab>();
    Firebase.initializeApp();
    globals.interests.get(forceNetwork: true);
    globals.moods.get(forceNetwork: true);
    globals.avatars.get(forceNetwork: true);
    globals.personality.get(forceNetwork: true);
    globals.meUser.get(forceNetwork: true);
    createToken();
  }

  void createToken() async {
    await globals.posts.get();
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
    globals.addPostCall('notification/token/', {"fcm_token": fcmToken}, overwrite: (body) => true);
    configureFCM();
  }

  void configureFCM () {
    void Function(Map<String, dynamic>) onNotification = (Map<String, dynamic> message) async {
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
        case 'Chat':
          int id = int.parse(message['data']['id']);
          Map<int, Found> founds = await globals.founds.get();
          globals.currentTab.set(PageTab.found);
          setState(() {
            _tabHistory.add(_currentTab);
            _currentTab = PageTab.found;
            navigatorKeys[_currentTab].currentState.pushNamed('/message', arguments: founds[id]);
          });
          break;
      }
    };

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        bool display = true;
        if(message['data'].contains('display')) display = message['data']['display'] == 'true';

        if(display){
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
                    onNotification(message);
                  },
                ),
              ],
            ),
          );
        }
      },
      onLaunch: onNotification,
      onResume: onNotification,
    );
  }

  Widget build(BuildContext context) {
    return createFutureWidget(globals.currentTab.get(), (PageTab cachedTab) {
      if(_currentTab == null) _currentTab = cachedTab;

      return WillPopScope(
        onWillPop: () async {
          bool canPop = await navigatorKeys[_currentTab].currentState.maybePop();
          if(!canPop){
            if(_tabHistory.isEmpty)
              return true;
            setState(() {
              _currentTab = _tabHistory.removeLast();
            });
            return false;
          }
          return false;
        },
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
                if(newTab == _currentTab){
                  navigatorKeys[_currentTab].currentState.popUntil(ModalRoute.withName('/'));
                }else{
                  globals.currentTab.set(newTab);
                  setState(() {
                    _tabHistory.add(_currentTab);
                    _currentTab = newTab;
                  });
                }
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
    });
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
