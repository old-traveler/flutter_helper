
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
        child: Text("二手"),
      ),
    );
  }

}