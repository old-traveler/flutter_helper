
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondMarketPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _SecondMarketPageState();
  }

}

class _SecondMarketPageState extends State<SecondMarketPage>{
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
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, //每行三列
                childAspectRatio: 1.0 //显示区域宽高相等
            ),
            itemCount: 10,
            itemBuilder: (context, index) {
              return Text("11");
            }),
      ),
    );
  }

}