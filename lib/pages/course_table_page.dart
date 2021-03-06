import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_header.dart';
import 'package:flutter_helper/api/net_api.dart';
import 'package:flutter_helper/entity/course_entity.dart';
import 'package:flutter_helper/http/http_manager.dart';
import 'package:flutter_helper/res/colors.dart';
import 'package:flutter_helper/res/strings.dart';
import 'package:flutter_helper/utils/course_util.dart';
import 'package:flutter_helper/utils/shared_preferences_util.dart';
import 'package:flutter_helper/utils/toast_util.dart';

class CourseTablePage extends StatefulWidget {
  final String number;

  CourseTablePage(this.number, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CourseTablePageState(number);
  }
}

class _CourseTablePageState extends State<CourseTablePage>
    with AutomaticKeepAliveClientMixin {
  List<List<CourseData>> _courseData = List();
  final String number;

  _CourseTablePageState(this.number);

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Image.network(
          YStrings.courseBackgroundUrl,
          fit: BoxFit.fitWidth,
          width: MediaQuery.of(context).size.width,
        ),
        EasyRefresh.custom(
          header: PhoenixHeader(),
          onRefresh: _onRefresh,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 0) {
                    return _getBottomDateTip();
                  }
                  return _getItemWidget(context, index - 1);
                },
                childCount: _courseData.length + 1,
              ),
            )
          ],
        ),
      ],
    ));
  }

  Future _onRefresh() async {
    var code = await SharedPreferencesUtil.getRememberCodeApp();
    Response response = await HttpManager.getInstance()
        .get(NetApi.COURSE_URL + "$number/$code");
    if (response == null) {
      ToastUtil.show(context: context, msg: "网络不给力");
      return;
    }
    var course = CourseEntity.fromJson(json.decode(response.toString()));
    if (course.code == HttpStatus.ok) {
      setState(() {
        _courseData = CourseUtil.getCourseModel(course.data);
      });
    }
  }

  Widget _getItemWidget(BuildContext context, int index) {
    return Row(mainAxisSize: MainAxisSize.max, children: _getChildren(index));
  }

  List<Widget> _getChildren(int index) {
    List<Widget> widget = List();
    List<CourseData> course = _courseData[index];
    for (var value in course) {
      if (value == null) {
        widget.add(Expanded(
          flex: 1,
          child: Text(""),
        ));
      } else {
        widget.add(Expanded(
          flex: 1,
          child: _getCourseItem(value),
        ));
      }
    }
    return widget;
  }

  Widget _getCourseItem(CourseData courseItem) {
    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      height: 120,
      child: Card(
        margin: EdgeInsets.all(2),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        color: courseItem.qsz == "1"
            ? YColors.courseBgColor[Random().nextInt(6)]
            : Color(0x98A9A9A9),
        child: Padding(
          padding: EdgeInsets.only(top: 4, bottom: 4, left: 2, right: 2),
          child: Text(CourseUtil.getCourseName(courseItem),
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              textScaleFactor: 0.9),
        ),
      ),
    );
  }

  Widget _getBottomDateTip() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      margin: EdgeInsets.only(bottom: 2),
      child: Row(
        children: _getDateItemTip(),
      ),
    );
  }

  List<Widget> _getDateItemTip() {
    List<String> date = CourseUtil.getCurDayOfWeek(CourseUtil.getCurWeek());
    List<Widget> widget = List(date.length);
    int curDayIndex = CourseUtil.getCurDayInCurWeekIndex();
    for (int i = 0; i < date.length; i++) {
      widget[i] = Expanded(
        flex: 1,
        child: Container(
            alignment: Alignment.center,
            height: 35,
            decoration: i == curDayIndex
                ? BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(1),
                        bottomRight: Radius.circular(1)))
                : null,
            child: Text(
              date[i],
              textScaleFactor: 0.8,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: i == curDayIndex ? Colors.white : Colors.black),
            )),
      );
    }
    return widget;
  }

  @override
  bool get wantKeepAlive => true;
}
