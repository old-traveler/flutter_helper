import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helper/entity/user_entity.dart';
import 'package:flutter_helper/res/strings.dart';

class UserInfoPage extends StatelessWidget {
  final UserData userData;

  const UserInfoPage({Key key, this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _getUserInfoWidget(),
            _getUserMoreInfoWidget(),
          ],
        ),
      ),
    );
  }

  Widget _getUserInfoWidget() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 3,
      margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
      child: Stack(
        children: <Widget>[
          Container(
            height: 100,
            padding: EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            child: ClipOval(
              child: Image.network(
                YStrings.baseImageUrl + userData.headPicThumb,
                width: 65,
                height: 65,
              ),
            ),
          ),
          Positioned(
            top: 25,
            left: 100,
            child: Text(
              userData.username.isEmpty ? userData.trueName : userData.username,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Positioned(
            top: 57,
            left: 100,
            child: Text(
              userData.bio.isEmpty ? "暂无签名" : userData.bio,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  Widget _getUserMoreInfoWidget() {
    return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        margin: EdgeInsets.all(10),
        child: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 18),
          child: Text(
            "姓名：${userData.trueName}\n\n学号：${userData.studentKH}\n\n学院：${userData.depName}\n\n班级：${userData.className}\n\n高中：${userData.school}",
            style: TextStyle(fontSize: 16),
          ),
        ));
  }
}
