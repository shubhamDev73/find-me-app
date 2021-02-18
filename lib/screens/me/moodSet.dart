import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:findme/widgets/misc.dart';

import 'package:findme/models/user.dart';

import 'package:findme/API.dart';

import 'package:findme/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';

Future<User> fetchUser() async {
  final response = await GET('me/');

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load user: ${response.statusCode}');
  }
}

Future<List<dynamic>> fetchAvatars() async {
  final response = await GET('avatars/2/');
  //List<dynamic> avatarList=[];
  if (response.statusCode == 200) {
    var avatars = jsonDecode(response.body);
    //callback(avatars);
    List<dynamic>  avatarList=avatars!=null?List.from(avatars):null;
    print(avatarList);
    //callback(avatarList);
    return avatars;
  } else {
    throw Exception('Failed to load avatars: ${response.statusCode}');
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



FutureBuilder<List<dynamic>> createAvatarList(Future<List<dynamic>> avatars, Function callback) {
  return FutureBuilder<List<dynamic>>(
      future: avatars,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return ListView(
            scrollDirection: Axis.horizontal,
            children: (snapshot.data)
                .map((x) => Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  child: Column(
                    children: [
                      Image.network(x["url"], width: 160,),
                      Text(x["mood"])
                    ],
                  ),
                  onTap: () => callback(x['mood']),
                );
              },
            ))
                .toList(),

          );
        }
        else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      });

}

class HistoryItem extends StatelessWidget {
  HistoryItem({
    Key key,
    @required this.mood,
    @required this.parent,
  }) : super(key: key);


  final String mood;

  final _MoodSetState parent;

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          SvgPicture.asset(
            Assets.moods[mood]['weather'],
            //width: 50,
            height:50,
            //height:50,
          ),
          //Text(mood),
          Container(
            width: 1,
            //,
            height:20,
            color: Colors.black,
          )
        ],
      );
  }
}

class MoodSet extends StatefulWidget {
  @override
  _MoodSetState createState() => _MoodSetState();
}

class _MoodSetState extends State<MoodSet> {
  Future<User> futureUser;
  String mood = '';
  String currentmood = '';
  var moodHistory=["Cheerful","Mysterious","Gloomy","Angry"];
  // var avatarList =[];
  List<dynamic> avatarList = [];
  var avatars ;
  int set;


  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
    mood='Cheerful'; //FIXME: Set and Get from futureUser
    currentmood=mood;
    set=1;

    avatars=fetchAvatars();
    print(avatars);


  }

  void _setMood(String a) {
    setState(() {
      mood=a;
      currentmood=a;
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
              child: /*GestureDetector(
                onTap: () {
                  //Navigator.of(context).pushNamed('/moodHistory');
                  setState(() {
                    set=(set==1)?0:1;
                  });
                },
                child: */
              CarouselSlider(
                options: CarouselOptions(
                    height: 100,
                    viewportFraction: 0.2,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    initialPage: moodHistory.length,
                    aspectRatio: 2.0,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      setState(() {
                        mood = (moodHistory+[currentmood])[index];
                        if(index!=moodHistory.length) set=0;
                        else set=1;
                      });
                    }),
                items: (moodHistory+[currentmood])
                    .map((x) => Builder(
                  builder: (BuildContext context) {
                    return HistoryItem(

                      mood: x,

                      parent:this,

                    );
                  },
                ))
                    .toList(),


              ),
                     //],
                ),

            //),
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
            Visibility(visible:set==1,
              child:Expanded(
                flex: 4,
                child: createAvatarList(avatars,
                        (String newAvatarMood) {
                      _setMood(newAvatarMood);
                    }
                )

              ),
            replacement: SizedBox(
              height: 200, // Some height
              child:Column(
              children:<Widget>[
                Expanded(
                  flex: 1,
                  child: Text('felt '+mood+' on (date)'),
                ),
                Expanded(
                  flex: 1,
                  child: Text('(date)'),
                ),
                Expanded(
                  flex: 2,
                  child: Text('FIXME: comment goes here'),
                ),
              ],
            ),
            ),
            ),
          ],
        ),
        )
      
    );
  }


}
