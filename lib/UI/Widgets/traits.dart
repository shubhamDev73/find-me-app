import 'package:findme/configs/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math';
import '../../constant.dart';

class TraitsElements extends StatefulWidget {
  final String selectedElement;
  const TraitsElements({
    this.selectedElement,
    Key key,
  }) : super(key: key);

  @override
  _TraitsElementsState createState() => _TraitsElementsState();
}

class _TraitsElementsState extends State<TraitsElements>
    with SingleTickerProviderStateMixin {
  AnimationController progressController;
  Animation<double> animation;
  @override
  void initState() {
    super.initState();
    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animation = Tween<double>(begin: 0, end: 80).animate(progressController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 30,
      top: 115,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/profileLandingTrait",
                  arguments: "Earth");
            },
            child: MoodIcons(
              icon: SvgPicture.asset(
                Assets.moodOne,
              ),
              sweepAngle: 100,
              progress: 100,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/profileLandingTrait",
                  arguments: "Earth");
            },
            child: MoodIcons(
              icon: SvgPicture.asset(
                Assets.moodTwo,
              ),
              sweepAngle: 97,
              progress: 38,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/profileLandingTrait",
                  arguments: "Earth");
            },
            child: MoodIcons(
              icon: SvgPicture.asset(
                Assets.moodThree,
              ),
              sweepAngle: 57,
              progress: 77,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/profileLandingTrait",
                  arguments: "Earth");
            },
            child: MoodIcons(
              icon: SvgPicture.asset(
                Assets.moodFour,
              ),
              sweepAngle: 0,
              progress: 25,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/profileLandingTrait",
                  arguments: "Earth");
            },
            child: MoodIcons(
              icon: SvgPicture.asset(
                Assets.moodFive,
              ),
              sweepAngle: 60,
              progress: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class MoodIcons extends StatelessWidget {
  final Widget icon;
  final double sweepAngle;
  final double progress;
  const MoodIcons({Key key, this.sweepAngle, this.icon, this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: CircleProgress(
          progress, sweepAngle), // this will add custom painter after child
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
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white),
          ),
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
  double sweepAngle;

  CircleProgress(this.currentProgress, this.sweepAngle);

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

    double angle = 2 * pi * (currentProgress / 100);

    canvas.drawArc(Rect.fromCircle(center: center, radius: 23), sweepAngle,
        angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
