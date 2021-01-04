import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:findme/UI/Widgets/menuButton.dart';

import 'package:findme/data/models/user.dart';

import 'package:findme/API.dart';

import 'package:findme/configs/assets.dart';

Future<User> fetchUser() async {
  final response = await GET('me/');

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load user: ${response.statusCode}');
  }
}

FutureBuilder<User> createUser (Future<User> futureUser) {
  return FutureBuilder<User>(
    future: futureUser,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Text(
          snapshot.data.nick,
          style: GoogleFonts.comfortaa(
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }

      // By default, show a loading spinner.
      return CircularProgressIndicator();
    },
  );
}

/*FutureBuilder<User> createAvatar (Future<User> futureUser) {
  return FutureBuilder<User>(
    future: futureUser,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Image.network(
          snapshot.data.avatar,
          width: 250,
          height: 250,
        );
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }

      // By default, show a loading spinner.
      return CircularProgressIndicator();
    },
  );
}
*/
class MoodSet extends StatefulWidget {
  @override
  _MoodSetState createState() => _MoodSetState();
}

class _MoodSetState extends State<MoodSet> {
  Future<User> futureUser;
  String mood = '';

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
    mood='Happy'; //FIXME: Set and Get from futureUser
  }

  Image _setMood(String a) {
    setState(() {
      mood=a;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Container(
                    //color: Color(0xffE0F7FA),
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.more_vert),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/moodHistory');
                },
                child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    width: 160.0,
                    color: Colors.red,
                  ),
                  Container(
                    width: 160.0,
                    color: Colors.blue,
                  ),
                  Container(
                    width: 160.0,
                    color: Colors.green,
                  ),
                  Container(
                    width: 160.0,
                    color: Colors.yellow,
                  ),
                  Container(
                    width: 160.0,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
            ),
            Expanded(
                flex:6,
                child: //Container(
                   Center(
                    //child: createAvatar(futureUser),
                    //Column(
                      child:
                        Image(
                        image:AssetImage(Assets.moods[mood]['avatar']),
                        //width: 300,
                        //height: 300,
                        ),
                        //Text(mood),

                    ),
                  //),
                ),
            //),
            Expanded(
                flex:1,
                //child: Text(mood)
                child: createUser(futureUser)
            ),
            Expanded(
              flex: 4,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [//<Widget>[
                  GestureDetector(
                    child: Column(
                      children: [
                        Image(image:AssetImage(Assets.moods['Happy']['avatar']),width: 160,),
                        Text('Happy')
                      ],
                    ),
                    onTap: () => _setMood('Happy'),
                    //SvgPicture.asset(Assets.traits['Fire']['negative'],width: 160,),
                  ),
                  GestureDetector(
                    child: Column(
                      children: [
                        Image(image:AssetImage(Assets.moods['Gloomy']['avatar']),width: 160,),
                        Text('Gloomy')
                      ],
                    ),
                    onTap: () => _setMood('Gloomy'),
                  ),
                  GestureDetector(
                    child: Column(
                      children: [
                        Image(image:AssetImage(Assets.moods['Mysterious']['avatar']),width: 160,),
                        Text('Mysterious')
                      ],
                    ),
                    onTap: () => _setMood('Mysterious'),
                  ),
                ],//],
              ),
            ),
            MenuButton(),
          ],
        ),
      ),
    );
  }
}
