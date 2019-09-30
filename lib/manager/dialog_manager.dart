import 'package:flutter/material.dart';
import 'package:flutter_helper/pages/login_page.dart';
import 'package:flutter_helper/res/colors.dart';
import 'package:flutter_helper/utils/shared_preferences_util.dart';
import 'package:flutter_helper/utils/theme_provide.dart';
import 'package:provide/provide.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DialogManager {
  static void showThemeDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Icon(
                Icons.color_lens,
                color: Theme.of(context).accentColor,
              ),
              SizedBox(width: 5),
              Text(
                '切换主题',
                style: TextStyle(
                    fontSize: 14, color: Theme.of(context).accentColor),
              )
            ],
          ),
          content: Container(
            margin: EdgeInsets.only(top: 5),
            width: MediaQuery.of(context).size.width * 0.9,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  childAspectRatio: 1),
              shrinkWrap: true,
              itemCount: YColors.themeColor.keys.length,
              itemBuilder: (BuildContext context, int position) {
                return _getItemWidget(context, position);
              },
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('关闭',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Widget _getItemWidget(BuildContext context, int position) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: new Border.all(
              width: 2.0,
              color: YColors.themeColor[position]['colorPrimaryLight']),
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: YColors.themeColor[position]['colorAccent'],
        ),
      ),
      onTap: () async {
        Provide.value<ThemeProvide>(context).setTheme(position);
        //存储主题下标
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setInt("themeIndex", position);
        Navigator.of(context).pop();
      },
    );
  }

  static void showLogoutDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("提示"),
            content: new Text("是否退出登录？"),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  SharedPreferencesUtil.clearUserInfo();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => route == null);
                },
                child: new Text("确认"),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("取消"),
              ),
            ],
          );
        });
  }
}
