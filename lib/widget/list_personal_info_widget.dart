import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helper/res/strings.dart';

class ListPersonalInfoWidget extends StatelessWidget {
  final String headPic;

  final String username;

  final String desc;

  final String time;

  const ListPersonalInfoWidget(
      {Key key, this.headPic, this.username, this.desc, this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        Container(
          height: 55,
        ),
        Positioned(
          left: 10,
          top: 10,
          width: 45,
          height: 45,
          child: ClipOval(
            child: Image.network(YStrings.baseImageUrl + headPic),
          ),
        ),
        Positioned(
          left: 63,
          top: 13,
          child: Text(
            username,
            style: TextStyle(color: Theme.of(context).primaryColor),
            textScaleFactor: 1.1,
          ),
        ),
        Positioned(
          left: 63,
          top: 35,
          child: Text(
            desc,
            style: TextStyle(color: Colors.grey),
            textScaleFactor: 0.9,
          ),
        ),
        Positioned(
          right: 10,
          top: 13,
          child: Text(time,
              style: TextStyle(color: Colors.grey), textScaleFactor: 0.8),
        )
      ],
    );
  }
}
