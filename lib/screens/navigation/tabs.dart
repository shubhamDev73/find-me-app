import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:findme/models/pageTab.dart';
import 'package:findme/constant.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/main.dart' as main;
import 'package:findme/globals.dart' as globals;
import 'package:findme/events.dart' as events;

class TabbedScreen extends StatefulWidget {

  final PageTab initTab;
  TabbedScreen({this.initTab: PageTab.me});

  @override
  _TabbedScreenState createState() => _TabbedScreenState();
}

class _TabbedScreenState extends State<TabbedScreen> {

  PageTab? _currentTab;
  List<PageTab> _tabHistory = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    globals.interests.get(forceNetwork: true);
    globals.moods.get(forceNetwork: true);
    globals.avatars.get(forceNetwork: true);
    globals.personality.get(forceNetwork: true);
    globals.meUser.get(forceNetwork: true);
    createToken();

    globals.onTabChanged = (PageTab newTab) => setState(() {
      _tabHistory.add(_currentTab!);
      _currentTab = newTab;
      if(globals.pageOnTabChange != null){
        navigatorKeys[_currentTab]!.currentState!.pushNamed(globals.pageOnTabChange!['route'], arguments: globals.pageOnTabChange!['arguments']);
        globals.pageOnTabChange = null;
      }
    });
  }

  void createToken() async {
    await globals.posts.get();
    String fcmToken = (await FirebaseMessaging.instance.getToken())!;
    globals.addPostCall('notification/token/', {"fcm_token": fcmToken}, overwrite: (body) => true);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      main.onNotification(message.data);

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
            actions: <Widget>[
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
    return createFutureWidget(globals.currentTab.get(), (PageTab cachedTab) {
      if(_currentTab == null) _currentTab = cachedTab;

      return WillPopScope(
        onWillPop: () async {
          bool canPop = await navigatorKeys[_currentTab]!.currentState!.maybePop();
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
            height: 50,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: PageTab.values.map<BottomNavigationBarItem>((PageTab tab) =>
                tabButton(icon: tabIcon[tab]!, selected: _currentTab == tab)
              ).toList(),
              currentIndex: PageTab.values.indexOf(_currentTab!),
              onTap: (index) {
                PageTab newTab = PageTab.values[index];
                if(newTab == _currentTab)
                  navigatorKeys[_currentTab]!.currentState!.popUntil(ModalRoute.withName('/'));
                else
                  globals.currentTab.set(newTab);
                events.sendEvent('tabSelect', {"tab": newTab.toString()});
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
