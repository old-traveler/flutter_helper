import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helper/entity/user_entity.dart';
import 'package:flutter_helper/pages/user_info_page.dart';
import 'package:flutter_helper/res/strings.dart';

class PortraitWidget extends StatelessWidget {
  final UserData _userData;

  PortraitWidget(this._userData);

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      //头像
      currentAccountPicture: GestureDetector(
        //圆形头像
        child: ClipOval(
          child: Image.network(YStrings.baseImageUrl + _userData.headPicThumb),
        ),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserInfoPage()),
          );
        },
      ),
      //其他头像
      otherAccountsPictures: <Widget>[
        IconButton(
            icon: Icon(
              Icons.stars,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
      accountName: Text(
        _userData.username,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      accountEmail: Text(_userData.bio),
    );
  }
}
