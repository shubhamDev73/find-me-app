import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:findme/configs/assets.dart';

class MenuButton extends StatelessWidget {

  final String tab;

  MenuButton(this.tab);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Row(
        children: [
          menuButton(
              key: "tab_me",
              context: context,
              selected: tab == "me",
              icon: Assets.me),
          menuButton(
              key: "tab_found",
              context: context,
              selected: tab == "found",
              icon: Assets.find),
        ],
      ),
    );
  }
}

Widget menuButton({key, context, scaffoldKey, selected, icon}) {
  return Expanded(
    flex: 2,
    child: InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(key == "tab_found" ? '/chatLanding' : '/home');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: selected ? Radius.circular(0.0) : Radius.circular(8.0),
            topRight: selected ? Radius.circular(0.0) : Radius.circular(0.0),
          ),
          color: selected ? Colors.white : Color(0xff00ACC1),
        ),
        height: 84,
        width: 50,
        child: SvgPicture.asset(
          icon,
          color: selected ? Color(0xff00ACC1) : Colors.white,
        ),
      ),
    ),
  );
}
