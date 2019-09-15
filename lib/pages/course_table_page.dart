import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseTablePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CourseTablePageState();
  }
}

class _CourseTablePageState extends State<CourseTablePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Theme.of(context).accentColor,
            Theme.of(context).primaryColor
          ])),
      child: Center(
        child: Text("课表"),
      ),
    );
  }
}
