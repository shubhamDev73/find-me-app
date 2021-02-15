import 'dart:convert';

import 'package:findme/UI/Widgets/activityButtons.dart';
import 'package:findme/UI/Widgets/addInterestsButton.dart';
import 'package:findme/UI/Widgets/menuButton.dart';
import 'package:findme/data/models/interests.dart';
import 'package:flutter/material.dart';
import 'package:findme/API.dart';

import 'package:findme/Model/Item.dart';

import 'package:findme/UI/Widgets/Button.dart';

class AddUserInterest extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  List buttonNames = [
    'APP',
    'APP2',
    'APP',
    'APP',
    'APP3',
    'APP',
    'APP',
    'APP',
    'APP6',
    'APP',
    'APP',
    'APP',
    'APP6',
    'APP',
    'APP',
    'APP6',
    'APP',
    'APP',
    'APP',
    'APP6',
    'APP9',
    'APP',
    'APP',
    'APP',
    'APP6',
    'APP',
    'APP',
    'APP',
    'APP6',
    'APP',
    'APP',
    'APP6',
    'APP',
    'APP',
    'APP',
    'APP6',
    'APP9'
  ];
  @override
  Widget build(BuildContext context) {
    var itemList = Item().items;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(maxHeight: 67, minHeight: 67),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.more_vert),
                      ],
                    ),
                  ),
                  Container(
                    child: Text(
                      "Interests",
                      style: TextStyle(
                        fontFamily: 'QuickSand',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment(0.0, 0.0),
                  ),
                  Container(
                    child: Text(
                      "tap and tap",
                      style: TextStyle(
                        fontFamily: 'QuickSand',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    alignment: Alignment(0.0, 0.75),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Container(
                constraints: BoxConstraints(minWidth: 245, maxWidth: 245),
                child: Scrollbar(
                  thickness: 0,
                  isAlwaysShown: true,
                  controller: _scrollController,
                  child: GridView(
                      controller: _scrollController,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 3.3,
                        mainAxisSpacing: 30,
                        crossAxisSpacing: 9,
                        crossAxisCount: 3,
                      ),
                      children: buttonNames
                          .map(
                            (e) => InterestButton(
                          name: e,
                          function: () {},
                          amount: 2,
                          selected: false,
                        ),
                      )
                          .toList()),
                ),
              ),
              constraints: BoxConstraints(maxHeight: 517, minWidth: 517),
            ),
            MenuButton(),
          ],
        ),
      ),
    );
  }
}

class CustomScroll extends StatelessWidget {
  const CustomScroll({
    Key key,
    @required ScrollController scrollController,
    @required this.itemList,
  })  : _scrollController = scrollController,
        super(key: key);

  final ScrollController _scrollController;
  final List itemList;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 3,
      isAlwaysShown: true,
      controller: _scrollController,
      child: GridView(
          controller: _scrollController,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 3.3,
            mainAxisSpacing: 25,
            crossAxisCount: 3,
          ),
          children: itemList
              .map(
                (e) => CustomButton(e.title),
          )
              .toList()),
    );
  }
}
