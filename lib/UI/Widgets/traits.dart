import 'package:flutter/material.dart';

class TraitsElements extends StatelessWidget {
  const TraitsElements({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 35,
      top: 138,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 8,
                    color: Colors.grey.shade600,
                    spreadRadius: 0)
              ],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.verified_user,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 8,
                    color: Colors.grey.shade600,
                    spreadRadius: 0)
              ],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.supervised_user_circle,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 8,
                    color: Colors.grey.shade600,
                    spreadRadius: 0)
              ],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.login,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 8,
                    color: Colors.grey.shade600,
                    spreadRadius: 0)
              ],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 8,
                    color: Colors.grey.shade600,
                    spreadRadius: 0)
              ],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.access_alarm,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
