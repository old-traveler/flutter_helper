import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helper/api/net_api.dart';
import 'package:flutter_helper/entity/user_entity.dart';
import 'package:flutter_helper/http/http_manager.dart';
import 'package:flutter_helper/pages/home_page.dart';
import 'package:flutter_helper/pages/web_page.dart';
import 'package:flutter_helper/res/colors.dart';
import 'package:flutter_helper/res/strings.dart';
import 'package:flutter_helper/utils/shared_preferences_util.dart';
import 'package:flutter_helper/utils/theme_util.dart';
import 'package:flutter_helper/utils/toast_util.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _key = GlobalKey();
  bool _autoValidate = false;
  String username, password;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeUtil.getThemeByContext(context),
      home: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor
            ])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _getBodyWidget(),
        ),
      ),
    );
  }

  //获取bodyWidget
  Widget _getBodyWidget() {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 80,
        ),
        Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            _getInfoWidget(),
            _getPortraitWidget(),
            _getButtonWidget(),
          ],
        ),
        GestureDetector(
          child: Text(
            "没有账号？注册",
            style: TextStyle(color: YColors.color_fff),
            textAlign: TextAlign.center,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    WebPage(title: "注册账号", url: YStrings.registerUrl),
              ),
            );
          },
        ),
      ],
    );
  }

  //获取输入框面板widget
  Widget _getInfoWidget() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      padding: EdgeInsets.all(40),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            autovalidate: _autoValidate,
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _getTextFormField(false),
                SizedBox(
                  height: 20,
                ),
                _getTextFormField(true),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //获取文本输入widget,password为是否为密码输入框,false为账号输入框
  TextFormField _getTextFormField(bool password) {
    return TextFormField(
      obscureText: password,
      keyboardType: password ? TextInputType.text : TextInputType.number,
      textInputAction: password ? TextInputAction.done : TextInputAction.next,
      decoration: InputDecoration(
          icon: Icon(password ? Icons.lock_outline : Icons.person_outline),
          labelText: password ? "请输入密码" : "请输入学号"),
      validator: password ? _validatePassword : _validateUsername,
      onSaved: (text) {
        setState(() {
          if (password) {
            this.password = text;
          } else {
            this.username = text;
          }
        });
      },
    );
  }

  //验证用户名输入是否为空
  String _validateUsername(String value) {
    if (value.isEmpty) {
      return "账号不能为空";
    }
    return null;
  }

  //验证密码输入是否为空
  String _validatePassword(String value) {
    if (value.isEmpty) {
      return "密码不能为空";
    }
    return null;
  }

  Positioned _getPortraitWidget() {
    return Positioned(
      top: 55,
      left: MediaQuery.of(context).size.width / 2 - 35,
      child: Center(
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).accentColor,
            image: DecorationImage(
              image: AssetImage("lib/res/images/ic_logo.png"),
            ),
            boxShadow: [
              BoxShadow(
                //左右、上下阴影的距离
                offset: Offset(0, 0),
                //阴影颜色
                color: Colors.grey,
                //模糊距离
                blurRadius: 8,
                //不模糊距离
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Positioned _getButtonWidget() {
    return Positioned(
      bottom: 20,
      left: 130,
      right: 130,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        elevation: 5,
        highlightElevation: 10,
        textColor: Colors.white,
        padding: EdgeInsets.all(0.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            gradient: LinearGradient(
              colors: <Color>[
                Theme.of(context).accentColor,
                Theme.of(context).primaryColorDark,
              ],
            ),
          ),
          padding: EdgeInsets.all(10.0),
          child: Text(
            "登录",
            style: TextStyle(fontSize: 20),
          ),
        ),
        onPressed: () {
          if (_key.currentState.validate()) {
            _key.currentState.save();
            _doLogin();
          } else {
            setState(() {
              _autoValidate = true;
            });
          }
        },
      ),
    );
  }

  Future _doLogin() async {
    var response = await HttpManager.getInstance()
        .get(NetApi.LOGIN_URL + "$username/$password/0");
    Map userMap = json.decode(response.toString());
    var user = UserEntity.fromJson(userMap);
    if (user != null && user.code == 200 && user.data != null) {
      SharedPreferencesUtil.saveUserInfo(user);
      ToastUtil.show(context: context, msg: "登录成功");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomePage(user.data)));
    } else if (user != null && user.msg != null) {
      ToastUtil.show(context: context, msg: user.msg);
    } else {
      ToastUtil.show(context: context, msg: "请检查网络");
    }
  }
}
