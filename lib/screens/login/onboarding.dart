import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:findme/assets.dart';
import 'package:findme/constant.dart';
import 'package:findme/widgets/misc.dart';

class OnboardingScreens extends StatefulWidget {
  @override
  _OnboardingScreensState createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {

  int slideIndex = 0;
  PageController controller = new PageController();

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.white : Colors.transparent,
        border: isCurrentPage
            ? Border.all(color: Colors.transparent)
            : Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              ThemeColors.primaryColor,
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: PageView(
                controller: controller,
                onPageChanged: (index) {
                  setState(() {
                    slideIndex = index;
                  });
                },
                children: [
                  SlideTile(
                    imagePath: Assets.onboardingOne,
                    title: 'find',
                    description: 'discover people',
                  ),
                  SlideTile(
                    imagePath: Assets.onboardingTwo,
                    title: 'me',
                    description: 'discover thyself',
                  ),
                  SlideTile(
                    imagePath: Assets.onboardingThree,
                    title: 'find.me',
                    description: 'discover conversations',
                    isLast: true,
                  )
                ],
              ),
            ),
            Expanded(
              flex: slideIndex != 2 ? 1 : 4,
              child: Column(
                children: [
                  slideIndex == 2 ? Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Button(
                          type: 'secondary',
                          text: 'sign up',
                          onTap: () => Navigator.of(context).pushNamed('/register'),
                        ),
                      ),
                      Button(
                        type: 'secondary',
                        text: 'login',
                        onTap: () => Navigator.of(context).pushNamed('/login'),
                      ),
                    ],
                  ) : Container(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 3; i++)
                        _buildPageIndicator(i == slideIndex)
                    ],
                  ),
                  SizedBox(height: 6),
                  slideIndex != 2 ? GestureDetector(
                    onTap: () => controller.animateToPage(2,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.linear,
                    ),
                    child: Text(
                      'skip >',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ) : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SlideTile extends StatelessWidget {
  final String imagePath, title, description;
  final bool isLast;

  SlideTile({required this.imagePath, required this.title, required this.description, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: isLast ? MainAxisAlignment.end : MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'logo',
            child: SvgPicture.asset(imagePath),
          ),
          SizedBox(height: 8),
          Hero(
            tag: 'title',
            child: Text(
              title,
              style: TextStyle(
                fontSize: 46,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
          Hero(
            tag: 'description',
            child: Text(
              description,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
