import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:findme/widgets/chatItems.dart';
import 'package:findme/widgets/chatListItems.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/models/user.dart';
import 'package:findme/models/found.dart';
import 'package:findme/constant.dart';
import 'package:findme/globals.dart' as globals;

class FoundPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return createFutureWidget<User>(globals.getUser(), (User user) =>
      createFutureWidget<List<dynamic>>(globals.requests.get(), (List<dynamic> requests) =>
        createFutureWidget<List<dynamic>>(globals.finds.get(), (List<dynamic> finds) =>
          createFutureWidget<Map<int, Found>>(globals.founds.get(), (Map<int, Found> founds) {
            List<dynamic> users = [...requests, ...finds];
            int numRequests = requests.length;
            return Scaffold(
              body: SafeArea(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        color: ThemeColors.primaryColor,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: CachedNetworkImage(imageUrl: user.avatar['v1'], height: 75),
                              ),
                              Container(
                                width: 7,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Center(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      dynamic user = users[index];
                                      return FindListItem(
                                          id: user['id'],
                                          avatar: user['avatar']['v1'],
                                          nick: user['nick'],
                                          isRequest: index < numRequests
                                      );
                                    },
                                    itemCount: users.length,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: ChatList(founds: founds),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
