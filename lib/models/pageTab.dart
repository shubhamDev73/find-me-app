import 'package:flutter/material.dart';

import 'package:findme/assets.dart';
import 'package:findme/screens/meTab.dart';
import 'package:findme/screens/foundTab.dart';

enum PageTab { me, found }

final Map<PageTab, GlobalKey<NavigatorState>> navigatorKeys = {
  PageTab.me: GlobalKey<NavigatorState>(),
  PageTab.found: GlobalKey<NavigatorState>(),
};

final Map<PageTab, Widget> tabScreens = {
  PageTab.me: MeTab(navigatorKey: navigatorKeys[PageTab.me]),
  PageTab.found: FoundTab(navigatorKey: navigatorKeys[PageTab.found]),
};

const Map<PageTab, String> tabIcon = {
  PageTab.me: Assets.me,
  PageTab.found: Assets.found,
};
