import 'package:flutter/material.dart';
import 'package:flutter_helper/entity/user_entity.dart';
import 'package:flutter_helper/pages/home_page.dart';
import 'package:flutter_helper/pages/login_page.dart';
import 'package:flutter_helper/res/colors.dart';
import 'package:flutter_helper/res/strings.dart';
import 'package:flutter_helper/utils/shared_preferences_util.dart';
import 'package:flutter_helper/utils/theme_provide.dart';
import 'package:provide/provide.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  //初始化
  var theme = ThemeProvide();
  var providers = Providers();
  //将theme,favorite加到providers中
  providers..provide(Provider.function((context) => theme));

  int themeIndex = await getTheme();
  String code = await SharedPreferencesUtil.getRememberCodeApp();

  bool hasLogin = code != null && code.isNotEmpty;
  UserData userData;
  if (hasLogin) {
    userData = await SharedPreferencesUtil.getUserData();
  }

  runApp(ProviderNode(
    providers: providers,
    child: MyApp(themeIndex, hasLogin, userData),
  ));
}

Future<int> getTheme() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  int themeIndex = sp.getInt("themeIndex");
  return null == themeIndex ? 0 : themeIndex;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final int themeIndex;
  final bool hasLogin;
  final UserData userData;

  MyApp(this.themeIndex, this.hasLogin, this.userData);

  @override
  Widget build(BuildContext context) {
    return Provide<ThemeProvide>(
      builder: (context, child, theme) {
        return MaterialApp(
          title: YStrings.appName,
          theme: ThemeData(
              // This is the theme of your application.
              primaryColor: YColors.themeColor[theme.value != null
                  ? theme.value
                  : themeIndex]["primaryColor"],
              primaryColorDark: YColors.themeColor[theme.value != null
                  ? theme.value
                  : themeIndex]["primaryColorDark"],
              accentColor: YColors.themeColor[theme.value != null
                  ? theme.value
                  : themeIndex]["colorAccent"]),
          home: hasLogin ? HomePage(userData) : LoginPage(),
        );
      },
    );
  }
}
