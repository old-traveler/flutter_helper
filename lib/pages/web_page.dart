import 'package:flutter/material.dart';
import 'package:flutter_helper/utils/theme_util.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';

class WebPage extends StatelessWidget {
  final String url, title;

  WebPage({Key key, @required this.title, @required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeUtil.getThemeByContext(context),
      routes: {
        "/": (_) => WebviewScaffold(
              url: "$url",
              appBar: AppBar(
                //返回键 点击关闭
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.maybePop(context);
                    }),
                title: Text("$title"),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.share),
                    tooltip: '分享',
                    onPressed: () {
                      Share.share('【$title】\n$url');
                    },
                  ),
                ],
              ),
            ),
      },
    );
  }
}
