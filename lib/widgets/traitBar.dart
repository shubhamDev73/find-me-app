import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:findme/assets.dart';
import 'package:findme/constant.dart';

class TraitsElements extends StatelessWidget {

  final String selectedElement;
  final Map<String, dynamic> personality;
  final Function onClick;

  const TraitsElements({
    this.selectedElement,
    this.personality,
    this.onClick,
  });

  Widget createButton (String trait) {
    double value = personality[trait] is double ? personality[trait] : personality[trait]['value'];
    bool selected = selectedElement == trait;
    return GestureDetector(
      onTap: () {
        onClick(trait);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: selected ? 0.0 : 5.0),
        child: TraitIcon(
          icon: SvgPicture.asset(
            Assets.traits[trait]['icon'],
            color: value >= 0 ? ThemeColors.positiveTraitColor : ThemeColors.negativeTraitColor,
            width: selected ? 40 : 32,
            height: selected ? 40 : 32,
          ),
          progress: value.abs(),
          iconSize: selected ? 70 : 55,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: selectedElement == null ? 115 : 115,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          createButton("Water"),
          createButton("Space"),
          createButton("Fire"),
          createButton("Earth"),
          createButton("Air"),
        ],
      ),
    );
  }
}

class TraitIcon extends StatelessWidget {
  final Widget icon;
  final double progress;
  final double iconSize;

  const TraitIcon({Key key, this.icon, this.progress, this.iconSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: CircleProgress(progress),
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: Container(
          height: iconSize,
          width: iconSize,
          child: CircleAvatar(
            backgroundColor: ThemeColors.primaryColor,
            child: icon,
          ),
        ),
      ),
    );
  }
}

class CircleProgress extends CustomPainter {
  double currentProgress;

  CircleProgress(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint completeArc = Paint()
      ..strokeWidth = 1.5
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double radius = size.width / 2;
    double angle = 2 * pi * currentProgress;
    Offset center = Offset(radius, radius);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius + 2), pi / 2 - angle / 2, angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
