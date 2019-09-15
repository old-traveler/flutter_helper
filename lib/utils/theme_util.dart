
import 'package:flutter/material.dart';

class ThemeUtil{

  static ThemeData getThemeByContext(BuildContext context){
    return ThemeData(
        primaryColor: Theme.of(context).primaryColor,
        accentColor: Theme.of(context).accentColor,
        primaryColorDark: Theme.of(context).primaryColorDark);
  }



}