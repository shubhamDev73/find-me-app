import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:findme/assets.dart';
import 'package:findme/constant.dart';

double traitGap = 9;
double normalIconSize = 50;
double selectedIconSize = 64;
double normalSvgSize = 28;
double selectedSvgSize = 36;

class TraitButton extends StatelessWidget {

  final String trait;
  final double value;
  final void Function() onTap;
  final bool selected;

  TraitButton({required this.trait, required this.value, required this.onTap, this.selected = false});

  @override
  Widget build (BuildContext context) {
    return Container(
      height: selectedIconSize,
      width: selectedIconSize,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: selected ? selectedIconSize : normalIconSize,
          width: selected ? selectedIconSize : normalIconSize,
          padding: EdgeInsets.all(selected ? 0.0 : 5.0),
          child: TraitIcon(
            icon: SvgPicture.asset(
              Assets.traits[trait]!['icon'] as String,
              color: value >= 0 ? ThemeColors.positiveTraitColor : ThemeColors.negativeTraitColor,
              width: selected ? selectedSvgSize : normalSvgSize,
              height: selected ? selectedSvgSize : normalSvgSize,
            ),
            progress: value.abs(),
            iconSize: selected ? selectedIconSize : normalIconSize,
          ),
        ),
      ),
    );
  }

}

class TraitsElements extends StatelessWidget {

  final String? selectedElement;
  final Map<String, dynamic> personality;
  final Function onClick;

  const TraitsElements({
    this.selectedElement,
    required this.personality,
    required this.onClick,
  });

  Widget createButton (String trait) {
    return TraitButton(
      trait: trait,
      value: personality[trait] is double ? personality[trait] : personality[trait]['value'],
      onTap: () => onClick(trait),
      selected: selectedElement == trait,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        createButton("Air"),
        SizedBox(width: traitGap),
        createButton("Space"),
        SizedBox(width: traitGap),
        createButton("Water"),
        SizedBox(width: traitGap),
        createButton("Earth"),
        SizedBox(width: traitGap),
        createButton("Fire"),
      ],
    );
  }
}

class TraitIcon extends StatelessWidget {
  final Widget icon;
  final double progress;
  final double iconSize;

  const TraitIcon({required this.icon, required this.progress, required this.iconSize});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: CircleProgress(progress),
      child: Container(
        height: iconSize,
        width: iconSize,
        child: CircleAvatar(
          backgroundColor: ThemeColors.primaryColor,
          child: icon,
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
