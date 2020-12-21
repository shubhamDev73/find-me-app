import 'package:findme/configs/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math';
import '../../constant.dart';

class TraitsElements extends StatelessWidget {

  final String selectedElement;
  final Map<String, dynamic> personality;
  final Function onClick;

  const TraitsElements({
    this.selectedElement,
    this.personality,
    this.onClick,
  });

  GestureDetector createButton (String trait) {
    double value = personality[trait] is double ? personality[trait] : personality[trait]['value'];
    bool selected = selectedElement == trait;
    return GestureDetector(
      onTap: () {
        onClick(trait, personality);
      },
      child: MoodIcons(
        icon: SvgPicture.asset(
          Assets.traits[trait]['icon'],
          color: value >= 0 ? MyColors.positiveTraitColor : MyColors.negativeTraitColor,
          width: selected ? 40 : 30,
          height: selected ? 40 : 30,
        ),
        progress: value.abs(),
        selected: selected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 115,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          createButton("Water"), SizedBox(width: 15),
          createButton("Space"), SizedBox(width: 15),
          createButton("Fire"), SizedBox(width: 15),
          createButton("Earth"), SizedBox(width: 15),
          createButton("Air"),
        ],
      ),
    );
  }
}

class MoodIcons extends StatelessWidget {
  final Widget icon;
  final double progress;
  final bool selected;

  const MoodIcons({Key key, this.icon, this.progress, this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: CircleProgress(progress), // this will add custom painter after child
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Container(
          height: selected ? 65 : 50,
          width: selected ? 65 : 50,
          child: CircleAvatar(
            backgroundColor: MyColors.primaryColor,
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
      ..strokeWidth = 1
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double radius = size.width / 2;
    double angle = 2 * pi * currentProgress;
    Offset center = Offset(radius, radius);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius + 1), pi / 2 - angle / 2,
        angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
