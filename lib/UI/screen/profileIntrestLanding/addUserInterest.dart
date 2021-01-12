import 'dart:convert';

import 'package:findme/UI/Widgets/activityButtons.dart';
import 'package:findme/UI/Widgets/menuButton.dart';
import 'package:findme/data/models/intrests.dart';
import 'package:flutter/material.dart';
import 'package:findme/API.dart';

import 'package:findme/Model/Item.dart';

import 'package:findme/UI/Widgets/Button.dart';

class AddUserinterests extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var itemList = Item().items;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 0,
          bottom: 0,
          left: 25,
          right: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 140,
                ),
                Column(
                  children: [
                    Text(
                      'Button',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text('tap and tap'),
                  ],
                ),
                SizedBox(
                  width: 110,
                ),
                Icon(Icons.more_vert)
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            Expanded(
              child: CustomScroll(
                  scrollController: _scrollController, itemList: itemList),
            ),
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
