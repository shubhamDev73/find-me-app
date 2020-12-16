import 'package:findme/UI/Widgets/greatings/greatings.dart';
import 'package:findme/UI/Widgets/menuButton.dart';
import 'package:findme/UI/Widgets/traits.dart';
import 'package:findme/configs/assets.dart';
import 'package:findme/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class ProfileLandingTrait extends StatefulWidget {
  const ProfileLandingTrait({
    Key key,
  }) : super(key: key);
  @override
  _ProfileLandingTraitState createState() => _ProfileLandingTraitState();
}

class _ProfileLandingTraitState extends State<ProfileLandingTrait> {
  List items = ["Confident", "Fearful", "Interesting", "Noob", "Sexiest"];
  int height = 73;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  Container(
                    color: Color(0xffDFF7F9),
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.more_vert),
                      ],
                    ),
                  ),
                  Container(
                    height: 180,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Greating(
                          title: "Ether",
                          desc: "Ether shows how emotionally stable are you",
                        ),
                        TraitsElements(selectedElement: args),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Assets.fire),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.black,
                          inactiveTrackColor: Colors.black,
                          trackHeight: 1.0,
                          thumbColor: Colors.white,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 10.0),
                        ),
                        // ignore: missing_required_param
                        child: Slider(
                          value: height.toDouble(),
                          min: 0.0,
                          max: 100.0,
                          inactiveColor: Color(0xFF8D8E98),
                          // onChanged: (double newValue) {
                          //   setState(() {
                          //     height = newValue.round();
                          //   });
                          // },
                        ),
                      ),
                      SvgPicture.asset(
                        Assets.fire,
                        color: MyColors.primaryColor,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      child: Text(
                        "Take a test",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Your attributes for this trait"),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Color(0xffE0F7FA),
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      items[index],
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Text(
                  "Explore",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            MenuButton(),
          ],
        ),
      ),
    );
  }
}
