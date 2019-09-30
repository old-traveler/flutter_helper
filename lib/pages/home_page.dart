import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helper/entity/user_entity.dart';
import 'package:flutter_helper/manager/dialog_manager.dart';
import 'package:flutter_helper/pages/course_table_page.dart';
import 'package:flutter_helper/pages/lost_find_page.dart';
import 'package:flutter_helper/pages/second_market_page.dart';
import 'package:flutter_helper/pages/statement_page.dart';
import 'package:flutter_helper/res/strings.dart';
import 'package:flutter_helper/utils/toast_util.dart';
import 'package:flutter_helper/widget/head_portrait_widget.dart';

class HomePage extends StatefulWidget {
  final UserData userData;

  HomePage(this.userData, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState(userData);
  }
}

class _HomePageState extends State<HomePage> {
  final UserData userData;
  int _selectedIndex = 0;
  String title = YStrings.courseTable;
  var _pageController = PageController(initialPage: 0);
  var pages;

  _HomePageState(this.userData) {
    pages = <Widget>[
      CourseTablePage(userData.studentKH),
      StatementPage(userData.studentKH),
      SecondMarketPage(),
      LostFindPage()
    ];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: "搜索",
            onPressed: () {
              ToastUtil.show(context: context, msg: "搜索");
            },
          )
        ],
      ),
      body: PageView.builder(
        onPageChanged: _pageChange,
        controller: _pageController,
        itemCount: pages.length,
        itemBuilder: (BuildContext context, int index) {
          return pages[index];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.apps), title: Text(YStrings.courseTable)),
          BottomNavigationBarItem(
              icon: Icon(Icons.forum), title: Text(YStrings.statement)),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text(YStrings.secondMarket)),
          BottomNavigationBarItem(
              icon: Icon(Icons.flare), title: Text(YStrings.lostFind)),
        ],
        currentIndex: _selectedIndex,
        //显示模式
        type: BottomNavigationBarType.fixed,
        //选中颜色
        fixedColor: Theme.of(context).primaryColor,
        //点击事件
        onTap: _onItemTapped,
      ),
      drawer: getDrawerWidget(),
    );
  }

  void _pageChange(int index) {
    setState(() {
      _selectedIndex = index;
      //根据下标修改标题
      switch (index) {
        case 0:
          title = YStrings.courseTable;
          break;
        case 1:
          title = YStrings.statement;
          break;
        case 2:
          title = YStrings.secondMarket;
          break;
        case 3:
          title = YStrings.lostFind;
          break;
      }
    });
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    //bottomNavigationBar 和 PageView 关联
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  Widget getDrawerWidget() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          PortraitWidget(userData),
          ListTile(
            leading: Icon(Icons.lightbulb_outline),
            title: Text("查电费"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: Icon(Icons.schedule),
            title: Text("考试计划"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: Icon(Icons.grade),
            title: Text("我的成绩"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: Icon(Icons.local_library),
            title: Text("图书馆"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("校历"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("关于我们"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text("切换主题"),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              DialogManager.showThemeDialog(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("退出登录"),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              DialogManager.showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
