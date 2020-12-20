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
    return GestureDetector(
      onTap: () {
        onClick(trait, personality);
      },
      child: MoodIcons(
        icon: SvgPicture.asset(
          Assets.traits[trait],
        ),
        progress: value.abs(),
        positive: value >= 0,
        selected: selectedElement == trait,
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
          createButton("Water"), SizedBox(width: 20),
          createButton("Space"), SizedBox(width: 20),
          createButton("Fire"), SizedBox(width: 20),
          createButton("Earth"), SizedBox(width: 20),
          createButton("Air"),
        ],
      ),
    );
  }
}

class MoodIcons extends StatelessWidget {
  final Widget icon;
  final double progress;
  final bool positive;
  final bool selected;

  const MoodIcons({Key key, this.icon, this.progress, this.positive, this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: CircleProgress(progress), // this will add custom painter after child
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 2),
                blurRadius: 10,
                color: Colors.grey.shade400,
                spreadRadius: 0)
          ],
        ),
        child: Container(
          height: selected ? 60 : 45,
          width: selected ? 60 : 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white),
          ),
          child: CircleAvatar(
            backgroundColor: MyColors.primaryColor,
            child: icon,
            foregroundColor: positive ? MyColors.positiveTraitColor : MyColors.negativeTraitColor,
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
    //this is base circle
    // Paint outerCircle = Paint()
    //   ..strokeWidth = 1
    //   ..color = Colors.black
    //   ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 1
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    // double radius = min(size.width / 2, size.height / 2) - 10;

    // canvas.drawCircle(
    //     center, radius, outerCircle); // this draws main outer circle

    double angle = 2 * pi * currentProgress;

    canvas.drawArc(Rect.fromCircle(center: center, radius: 23), 0,
        angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
