import 'dart:convert';

import 'package:findme/UI/Widgets/interestButton.dart';
import 'package:findme/UI/Widgets/menuButton.dart';
import 'package:findme/data/models/interests.dart';
import 'package:flutter/material.dart';
import 'package:findme/API.dart';

FutureBuilder<List<Interest>> createInterests (Future<List<Interest>> futureInterests, ScrollController _scrollController) {
  return FutureBuilder<List<Interest>>(
    future: futureInterests,
    builder: (context, snapshot) {
      if(snapshot.hasData){
        return GridView(
            controller: _scrollController,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 3.3,
              mainAxisSpacing: 30,
              crossAxisSpacing: 9,
              crossAxisCount: 3,
            ),
            children: snapshot.data.map((Interest interest) => InterestButton(
              name: interest.name,
              function: () {},
              amount: interest.amount,
              selected: false,
            ),
            ).toList());
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }

      // By default, show a loading spinner.
      return CircularProgressIndicator();
    },
  );
}

class AddUserInterest extends StatefulWidget {

  @override
  _AddUserInterestState createState() => _AddUserInterestState();
}

class _AddUserInterestState extends State<AddUserInterest> {

  final ScrollController _scrollController = ScrollController();

  Future<List<Interest>> futureInterests;

  @override
  void initState () {
    super.initState();
    futureInterests = GETResponse<List<Interest>>('interests/',
      decoder: (result) => result.map<Interest>((item) => Interest.fromJson(item)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  child: createInterests(futureInterests, _scrollController),
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
