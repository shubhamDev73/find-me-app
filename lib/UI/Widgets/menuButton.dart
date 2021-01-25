import 'package:findme/configs/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Row(
        children: [
          menuButton(
              key: "Menu button 2",
              context: context,
              selected: true,
              icon: Assets.me),
          menuButton(
              key: "Menu button 3",
              context: context,
              selected: false,
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
        Navigator.of(context).pushNamed('/chatLanding');
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
