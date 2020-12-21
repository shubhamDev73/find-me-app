import 'package:findme/configs/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:findme/data/models/user.dart';

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

FutureBuilder<User> createAvatar (Future<User> futureUser) {
  return FutureBuilder<User>(
    future: futureUser,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Image.network(
          snapshot.data.avatar,
          width: 300,
          height: 300,
        );
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }

      // By default, show a loading spinner.
      return CircularProgressIndicator();
    },
  );
}


class UserInfo extends StatelessWidget {

  Future<User> user;

  UserInfo(Future<User> user) {
    this.user = user;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: 170,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                child: Center(
                  child: createAvatar(this.user),
                ),
              ),
              Positioned(
                top: 25,
                left: 130,
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.white),
                  child: SvgPicture.asset(
                    Assets.edit,
                    height: 50,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Column(
            children: [
              SizedBox(
                height: 18,
              ),
              createUser(this.user),
              SizedBox(
                height: 8,
              ),
              Text(
                "Lorem ipsum dolor sit amet",
                style: GoogleFonts.comfortaa(
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
