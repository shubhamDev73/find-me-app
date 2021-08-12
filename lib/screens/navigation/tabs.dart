import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:findme/models/pageTab.dart';
import 'package:findme/models/found.dart';
import 'package:findme/constant.dart';
import 'package:findme/globals.dart' as globals;
import 'package:findme/events.dart' as events;

void onNotification(Map<String, dynamic> data) async {
  switch(data['type']){
    case 'Found':
      globals.founds.get(forceNetwork: true);
      break;
    case 'Personality':
      globals.meUser.get(forceNetwork: true);
      break;
    case 'Chat':
      int id = int.parse(data['id']);
      Map<int, Found> founds = await globals.founds.get();
      globals.pageOnTabChange = {"tab": PageTab.found, "route": "/message", "arguments": founds[id]};
      break;
    case 'AvatarUpdate':
      int id = int.parse(data['id']);
      Map<String, Map<String, dynamic>> avatars = await globals.avatars.get();
      globals.founds.mappedUpdate(id, (Found found) {
        found.mood = data['mood'];
        found.avatar = avatars[data['base']]!['avatars'][data['mood']]['url'];
        return found;
      });
      break;
    case 'NickUpdate':
      int id = int.parse(data['id']);
      globals.founds.mappedUpdate(id, (Found found) {
        found.nick = data['nick'];
        return found;
      });
      break;
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  onNotification(message.data);
}

class TabbedScreen extends StatefulWidget {

  @override
  _TabbedScreenState createState() => _TabbedScreenState();
}

class _TabbedScreenState extends State<TabbedScreen> {

  PageTab _currentTab = PageTab.found;
  List<PageTab> _tabHistory = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    String fcmToken = (await FirebaseMessaging.instance.getToken())!;
    globals.addPostCall('notification/token/', {"fcm_token": fcmToken}, overwrite: (body) => true);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if(message.data['type'] != 'Chat') onNotification(message.data);

      bool display = true;
      if(message.data.containsKey('display')) display = message.data['display'] == 'true';

      if(display && message.notification != null){
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message.notification!.title!),
              subtitle: Text(message.notification!.body!),
            ),
            actions: [
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if(globals.pageOnTabChange != null){
      _currentTab = globals.pageOnTabChange!['tab'];
      navigatorKeys[_currentTab]!.currentState!.popUntil(ModalRoute.withName('/'));
      navigatorKeys[_currentTab]!.currentState!.pushNamed(globals.pageOnTabChange!['route'], arguments: globals.pageOnTabChange!['arguments']);
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
